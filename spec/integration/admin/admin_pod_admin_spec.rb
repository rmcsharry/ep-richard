require "rails_helper"

RSpec.describe "EZY admin", :js => false, :type => :feature do

  before { login_as_admin }

  describe "creating a pod admin" do
    it "should create a pod admin" do
      expect(PodAdmin.all.count).to eq(0)

      visit admin_path
      click_link 'Pod admins'
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
