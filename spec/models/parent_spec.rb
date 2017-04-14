require 'rails_helper'

RSpec.describe Parent, :type => :model do

  describe "phone number" do
    let(:parent) { Parent.new }

    before do
      parent.name = "Basil Safwat"
    end

    describe "less than 11 digits" do
      it "should be invalid" do
        parent.phone = "0"
        expect(parent.valid?).to eq(false)
      end
    end

    describe "exactly 11 digits" do
      describe "not starting 07" do
        it "should be invalid" do
          parent.phone = "06555555555"
          expect(parent.valid?).to eq(false)
        end
      end
      describe "starting 07" do
        it "should be valid" do
          parent.phone = "07555555555"
          expect(parent.valid?).to eq(true)
        end
      end
    end
  end

  describe "first name" do
    let(:p) { Parent.new }

    it "should return the first name" do
      p.name = "Basil Safwat"
      p.save
      expect(p.first_name).to eq("Basil")
      p.name = "Bill"
      p.save
      expect(p.first_name).to eq("Bill")
      p.name = "Bob P. Hope"
      p.save
      expect(p.first_name).to eq("Bob")
      p.name = "John Humphrey Richards"
      p.save
      expect(p.first_name).to eq("John")
    end
  end  

  describe "welcome sms" do
    let!(:pod) { Fabricate(:pod) }
    let!(:parent) { Fabricate(:parent, pod: pod) }
    let!(:pod_admin) { Fabricate(:pod_admin, name: "Mickey Mouse", pod: pod) }
    inviter_known_text = "invites you"
    inviter_not_known_text = "you are invited"

    context "sent flag" do
      it "should be set to true after a successful send" do
        parent.send_welcome_sms
        expect(parent.welcome_sms_sent).to eq(true)
      end
    end

    context "when we know the pod admin name" do
      # Note we are testing a private method here (use of send) because this method is important
      it "should include it in the message" do
        expect(parent.send(:build_welcome_message)).to include("Mickey Mouse")
        expect(parent.send(:build_welcome_message)).to include(inviter_known_text)
      end
    end

    context "when we only know the pod admin preferred name" do
      # Note we are testing a private method here (use of send) because this method is important
      it "should include it in the message" do
        pod_admin.name = nil
        pod_admin.preferred_name = 'Mick'

        expect(parent.send(:build_welcome_message)).to include("Mick")
        expect(parent.send(:build_welcome_message)).to include(inviter_known_text)
        expect(parent.send(:build_welcome_message)).not_to include("Mickey Mouse")
      end
    end

    context "when we don't know the pod admin name or preferred name" do
      # Note we are testing a private method here (use of send) because this method is important
      it "should change the message intro" do
        pod_admin.name = nil
        pod_admin.preferred_name = nil

        expect(parent.send(:build_welcome_message)).to include(inviter_not_known_text)
        expect(parent.send(:build_welcome_message)).not_to include(inviter_known_text)
      end
    end

    context "when the pod admin name is an empty string" do
      # Note we are testing a private method here (use of send) because this method is important
      it "should not use it" do
        pod_admin.name = ''
        pod_admin.preferred_name = nil

        expect(parent.send(:build_welcome_message)).to include(inviter_not_known_text)
        expect(parent.send(:build_welcome_message)).not_to include(inviter_known_text)
      end
    end

    context "when the pod admin preferred_name is an empty string" do
      # Note we are testing a private method here (use of send) because this method is important
      it "should not use it" do
        pod_admin.name = nil
        pod_admin.preferred_name = ' '

        expect(parent.send(:build_welcome_message)).to include(inviter_not_known_text)
        expect(parent.send(:build_welcome_message)).not_to include(inviter_known_text)
      end
    end

    context "when the pod admin name is only whitespace" do
      # Note we are testing a private method here (use of send) because this method is important
      it "should not use it" do
        pod_admin.name = ' '
        pod_admin.preferred_name = nil

        expect(parent.send(:build_welcome_message)).to include(inviter_not_known_text)
        expect(parent.send(:build_welcome_message)).not_to include(inviter_known_text)
      end
    end

    context "when the pod admin preferred_name is only whitespace" do
      # Note we are testing a private method here (use of send) because this method is important
      it "should not use it" do
        pod_admin.name = nil
        pod_admin.preferred_name = ' '

        expect(parent.send(:build_welcome_message)).to include(inviter_not_known_text)
        expect(parent.send(:build_welcome_message)).not_to include(inviter_known_text)
      end
    end

  end

  describe "notifications" do
    before do
      stub_send_sms
    end

    describe "a parent in a pod that is not live" do
      let(:pod) { Fabricate(:pod) }
      let(:parent) { Fabricate(:parent, pod: pod) }

      it "should not send them a notification" do
        expect(parent.notify).to eq(false)
      end
    end

    describe "a parent in a pod that is live and in week 0" do
      let(:pod) { Fabricate(:pod, go_live_date: Date.today) }
      let(:parent) { Fabricate(:parent, pod: pod) }

      it "should not send them a notification" do
        expect(parent.notify).to eq(false)
      end
    end

    describe "a parent in a pod that is live and in week 1" do
      let(:pod) { Fabricate(:pod, go_live_date: Date.today - 1.week) }
      let(:parent) { Fabricate(:parent, pod: pod) }

      describe "when there is a game for that week" do
        let!(:game1) { Fabricate(:game, in_default_set: true) }
        let!(:game2) { Fabricate(:game, did_you_know_fact: "The did you know fact.", top_tip: "The top tip.") }

        describe "when the parent has never been notified" do
          it "should send them a notification" do
            expect(parent.notify).to eq(true)
          end

          it "should not notify them twice" do
            expect(parent.notify).to eq(true)
            expect(parent.notify).to eq(false)
          end
        end

        describe "when the parent was notified 7 days ago" do
          before do
            parent.last_notification = Date.today - 7.days
            parent.save
          end
          it "should send them a notification" do
            expect(parent.notify).to eq(true)
          end
        end

        describe "when the parent was notified 7 days ago" do
          before do
            parent.last_notification = Date.today - 7.days
            parent.save
          end
          it "should send them a notification" do
            expect(parent.notify).to eq(true)
          end

          it "should not notify them twice" do
            expect(parent.notify).to eq(true)
            expect(parent.notify).to eq(false)
          end

          it "should be able to send the weekend sms when Sunday rolls around" do
            # note we cannot test for Sunday, it is specified in the job itself (lib/tasks)
            # so we just test that this method returns true
            # (ie. it will be able to send sms when Sunday arrives)
            expect(parent.send_weekend_sms).to eq(true)
          end

          it "should send the did you know fact on day 2 of that week" do
            expect(parent.send_did_you_know_fact(Date.today - 5.days)).to eq(true)
          end

          it "should send the top tip on day 4 of that week" do
            expect(parent.send_top_tip(Date.today - 3.days)).to eq(true)
          end
        end
      end

      describe "when there is not a game for that week" do
        let(:game1) { Fabricate(:game, in_default_set: true) }

        it "should not send them a notification" do
          expect(parent.notify).to eq(false)
        end

        it "should not be able to send the weekend sms when Sunday rolls around" do
          # note we cannot test for Sunday, it is specified in the job itself (lib/tasks)
          # so we just test that this method returns false
          # (ie. that it will not be able to send sms when Sunday arrives)
          expect(parent.send_weekend_sms).to eq(false)
        end

        it "should not send them the did you know fact" do
          expect(parent.send_did_you_know_fact).to eq(false)
        end

        it "should not send them the top tip" do
          expect(parent.send_top_tip).to eq(false)
        end
      end
    end
  end
end
