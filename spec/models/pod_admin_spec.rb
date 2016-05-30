require 'rails_helper'

RSpec.describe PodAdmin, :type => :model do

  describe "sending out the analytics email" do
    let(:pod) { Fabricate(:pod) }
    let(:pod_admin) { Fabricate(:pod_admin, pod: pod) }

    before do
      allow(PodAdminMailer).to receive(:analytics_email).and_return(true)
      allow(PodAdminMailer.analytics_email).to receive(:deliver).and_return(true)
    end

    context "when a pod is not live" do
      it "should not send out the analytics email" do
        expect(pod_admin.should_send_analytics_email?).to eq(false)
      end
    end
    
    context "when a pod is not active" do
      it "should not send out the analytics email" do
        pod.inactive_date = Date.yesterday
        expect(pod_admin.should_send_analytics_email?).to eq(false)
      end
    end

    context "when a pod is live" do
      before { pod.go_live_date = Date.today - 7.days }

      it "should update the last notified date" do
        expect(pod_admin.last_analytics_email_sent).to eq(nil)
        pod_admin.send_analytics_email
        expect(pod_admin.last_analytics_email_sent).to eq(Date.today)
      end

      describe "when the pod admin has been notified in the last 7 days" do
        it "should not send out the analytics email" do
          pod_admin.last_analytics_email_sent = Date.today
          expect(pod_admin.should_send_analytics_email?).to eq(false)
        end
      end

      describe "when the pod is still in week 0" do
        it "should not send out the analytics email" do
          pod.go_live_date = Date.today - 1.day
          expect(pod_admin.should_send_analytics_email?).to eq(false)
        end
      end

      describe "when the pod is in week 1" do
        it "should send out the analytics email" do
          pod.go_live_date = Date.today - 7.days
          expect(pod_admin.should_send_analytics_email?).to eq(true)
        end
      end

      describe "one week after the last game has been released" do
        it "should still send out the analytics email (last one)" do
          pod.go_live_date = Date.today - (Game.non_default.count + 1).weeks
          expect(pod_admin.should_send_analytics_email?).to eq(true)
        end
      end
      
      describe "two weeks after the last game has been released" do
        it "should not send out the analytics email" do
          pod.go_live_date = Date.today - (Game.non_default.count + 2).weeks
          expect(pod_admin.should_send_analytics_email?).to eq(false)
        end
      end
    end

    describe "sending out the greetings email" do
      let(:pod) { Fabricate(:pod) }
      let(:pod_admin) { Fabricate(:pod_admin, pod: pod) }

      before do
        allow(PodAdminMailer).to receive(:greetings_email).and_return(true)
        allow(PodAdminMailer.greetings_email).to receive(:deliver).and_return(true)
      end
    
      context "a day after new PodAdmin registers" do
        it "should send out the greetings email" do
          pod_admin.created_at = Date.yesterday
          expect(pod_admin.send_greetings_email).to eq(true)
        end
      end

      context "on the day the PodAdmin registers" do
        it "should snot end out the greetings email" do
          pod_admin.created_at = Date.today
          expect(pod_admin.send_greetings_email).to eq(false)
        end
      end
    end
    
    describe "sending out the trial reminder email" do
    end
    
  end
end
