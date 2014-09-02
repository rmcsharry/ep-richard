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
    before do
      Fabricate(:pod, name: 'Save the Children')
    end

    it "should create a pod admin" do
      expect(PodAdmin.all.count).to eq(0)

      visit admin_path
      click_link 'Pod admins'
      click_link 'Add new pod admin'
      fill_in 'Email', with: 'bsafwat+podadmin@gmail.com'
      fill_in 'Password', with: 'Password2'
      select('Save the Children', :from => 'pod_admin_pod_id')
      click_button 'Add pod admin'

      expect(PodAdmin.all.count).to eq(1)
      expect(PodAdmin.last.pod.name).to eq('Save the Children')
    end
  end

  describe "editing a pod admin" do
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'bsafwat+1@gmail.com', password: 'Password1') }

    it "lets you edit the pod admin" do
      visit admin_pod_admins_path
      click_link 'bsafwat+1@gmail.com'
      fill_in 'Email', with: 'bsafwat+2@gmail.com'
      fill_in 'Password', with: 'Password3'
      click_button 'Update pod admin'
      visit admin_pod_admins_path

      expect(page).not_to have_text('bsafwat+1@gmail.com')
      expect(page).to     have_text('bsafwat+2@gmail.com')
    end
  end

  describe "deleting a pod admin" do
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'bsafwat+deleteme@gmail.com') }

    it "deletes the pod admin" do
      visit edit_admin_pod_admin_path(pod_admin)
      click_button "Delete"

      expect(current_path).to eq(admin_pod_admins_path)
      expect(page).not_to have_content('bsafwat@gmail.com')
    end
  end

  describe "associating a pod admin to a pod" do
    it "should create the appropriate link"
  end

end
