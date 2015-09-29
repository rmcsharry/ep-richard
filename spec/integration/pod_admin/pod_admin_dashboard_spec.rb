require "rails_helper"

RSpec.describe "Pod admin dashboard", :js => false, :type => :feature do

  before { login_as_pod_admin }

  describe "number of comments" do
    let!(:pod) { Fabricate(:pod) }
    let!(:live_pod) { Fabricate(:pod, go_live_date: Time.now) }

    let!(:pod_admin) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
    let!(:pod_admin_live) { Fabricate(:pod_admin, email: 'test2@example.com', pod: live_pod ) }

    before do
      logout_admin
      login_as_specific_pod_admin(pod_admin)
    end

    it "should not show any dashboard info if the pod is not live" do
      visit "/pod_admin/"
      expect(page).not_to have_content('Dashboard')
    end

    it "should load the dashboard page if the pod is live" do
      logout_admin
      login_as_specific_pod_admin(pod_admin_live)
      visit "/pod_admin/"
      expect(page).to have_content('Dashboard')
    end

  end

end
