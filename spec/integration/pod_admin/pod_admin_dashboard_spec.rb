require "rails_helper"

RSpec.describe "Pod admin dashboard", :js => false, :type => :feature do

  let!(:pod) { Fabricate(:pod) }
  let!(:live_pod) { Fabricate(:pod, go_live_date: Time.now) }

  let!(:pod_admin_not_live) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
  let!(:pod_admin_live) { Fabricate(:pod_admin, email: 'test2@example.com', pod: live_pod ) }

  before do
    login_as_specific_pod_admin(pod_admin_live)
  end

  describe "number of comments" do

    it "should not show any dashboard info if the pod is not live" do
      logout_admin
      login_as_specific_pod_admin(pod_admin_not_live)
      visit "/pod_admin/"
      expect(page).not_to have_content('Dashboard')
    end

    it "should load the dashboard page if the pod is live" do
      visit "/pod_admin/"
      expect(page).to have_content('Dashboard')
    end

  end

end
