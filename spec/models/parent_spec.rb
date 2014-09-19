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
        let!(:game2) { Fabricate(:game) }

        describe "when the parent has never been notified" do
          it "should send them a notification" do
            expect(parent.notify).to eq(true)
          end

          it "should not notify them twice" do
            expect(parent.notify).to eq(true)
            expect(parent.notify).to eq(false)
          end
        end

        describe "when the parent was notified 6 days ago" do
          before do
            parent.last_notification = Date.today - 6.days
            parent.save
          end
          it "should not send them a notification" do
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

          it "should not notify them twice" do
            expect(parent.notify).to eq(true)
            expect(parent.notify).to eq(false)
          end
        end
      end

      describe "when there is not a game for that week" do
        let(:game1) { Fabricate(:game, in_default_set: true) }

        it "should not send them a notification" do
          expect(parent.notify).to eq(false)
        end
      end
    end

  end
end
