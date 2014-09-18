require "rails_helper"

RSpec.describe "Go live", :js => false, :type => :feature do

  describe "the go live date for a pod" do

    it "should initially be not set" do
      pod = Pod.create!(name: "New pod")
      expect(pod.go_live_date).to eq(nil)
    end

    it "should show a button if not set" do
      pod = Pod.create!(name: "New pod")
      pod_admin = Fabricate(:pod_admin, pod: pod)
      login_as_specific_pod_admin(pod_admin)
      expect(page).to have_button("Make this pod live")
    end

    describe "clicking the button" do
      before do
        pod = Pod.create!(name: "New pod")
        pod_admin = Fabricate(:pod_admin, pod: pod)
        login_as_specific_pod_admin(pod_admin)
        click_button "Make this pod live"
      end

      it "should set the go live date to today" do
        string = Date.today.strftime("%B %e, %Y")
        expect(page).to have_content(string)
      end

      it "should no longer show the button" do
        expect(page).not_to have_button("Make this pod live")
      end
    end

  end
end
