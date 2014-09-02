require "rails_helper"

RSpec.describe "EZY admin", :js => false, :type => :feature do

  before { login_as_admin }

  describe "listing the pod admins" do
    before do
      Fabricate(:pod_admin, email: 'bsafwat+1@gmail.com')
      Fabricate(:pod_admin, email: 'bsafwat+2@gmail.com')
    end

    it "should list all pod admins" do
      visit admin_pod_admins_path
      expect(page).to have_content('bsafwat+1@gmail.com')
      expect(page).to have_content('bsafwat+2@gmail.com')
    end
  end

  describe "creating a pod admin" do
    it "should create a pod admin" do
      expect(PodAdmin.all.count).to eq(0)

      visit admin_path
      click_link 'Pod admins'
      click_link 'Add new pod admin'
      fill_in 'Email', with: 'bsafwat+podadmin@gmail.com'
      fill_in 'Password', with: 'Password2'
      click_button 'Add pod admin'

      expect(PodAdmin.all.count).to eq(1)
    end
  end

  describe "editing a pod admin" do
    it "should edit the pod admin"
  end

  describe "deleting a pod admin" do
    it "should delete the pod admin"
  end

  describe "associating a pod admin to a pod" do
    it "should create the appropriate link"
  end

end
