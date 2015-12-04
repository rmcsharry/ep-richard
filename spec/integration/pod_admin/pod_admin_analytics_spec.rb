require "rails_helper"

RSpec.describe "Analytics email", :js => false, :type => :feature do

  let!(:pod)       { Fabricate(:pod, name: 'Brockley Pod') }
  let!(:pod_admin) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
  let!(:parent)    { Fabricate(:parent, name: 'Jen', phone: '07515444444', pod: pod ) }

  before do
    login_as_specific_pod_admin(pod_admin)
  end

  describe "the test page" do

    before { visit pod_admin_analytics_path }

    it "should be accessible" do
      expect(page).to have_content("Brockley Pod's Weekly Report")
    end

    it "should show the correct date range (the last week)" do
      start_date = Date.yesterday - 7.days
      end_date   = Date.yesterday
      expect(page).to have_content(start_date.strftime("%A, %b %d"))
      expect(page).to have_content(end_date.strftime("%A, %b %d"))
    end
  end

end
