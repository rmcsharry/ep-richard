require 'rails_helper'

RSpec.describe PodAdmin, :type => :model do

  describe "sending out the analytics email" do
    let(:pod) { Fabricate(:pod) }
    let(:pod_admin) { Fabricate(:pod_admin, pod: pod) }
    
    before do
      PodAdminMailer.stub(:analytics_email).and_return(true)
      PodAdminMailer.analytics_email.stub(:deliver).and_return(true)
    end

    describe "when a pod is not live" do
      it "should not send out the analytics email" do
        expect(pod_admin.should_send_analytics_email?).to eq(false)
      end
    end

    describe "when a pod is live" do
      before { pod.go_live_date = Date.today }

      it "should send out the analytics email" do
        expect(pod_admin.should_send_analytics_email?).to eq(true)
      end

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

    end

  end
end
