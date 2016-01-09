require 'rails_helper'

RSpec.describe PodAdmin, :type => :model do

  describe "sending out the analytics email" do
    let(:pod) { Fabricate(:pod) }
    let(:pod_admin) { Fabricate(:pod_admin, pod: pod) }

    before do
      allow(PodAdminMailer).to receive(:analytics_email).and_return(true)
      allow(PodAdminMailer.analytics_email).to receive(:deliver).and_return(true)
    end

    describe "when a pod is not live" do
      it "should not send out the analytics email" do
        expect(pod_admin.should_send_analytics_email?).to eq(false)
      end
    end

    describe "when a pod is live" do
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

      describe "a week after the last game" do
        it "should not send out the analytics email"
      end
    end

  end
end
