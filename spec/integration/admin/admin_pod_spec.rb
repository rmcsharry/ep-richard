require "rails_helper"

RSpec.describe "EZY admin", :js => false, :type => :feature do

  before { login_as_admin }

  describe "creating a pod" do
    it "should create a pod" do
      expect(Pod.all.length).to eq(0)

      visit admin_path
      click_link 'Pods'
      click_link 'Add new pod'
      fill_in 'Name', with: 'Save the Children'
      click_button 'Add pod'

      expect(Pod.all.length).to eq(1)
    end

    it "should show the pod on the pod index page" do
      Fabricate(:pod, name: 'Save the Children')
      Fabricate(:pod, name: 'Hackney Council')
      visit admin_pods_path

      expect(page).to have_content('Save the Children')
      expect(page).to have_content('Hackney Council')
    end
  end

  describe "editing a pod" do
    it "should edit the pod" do
      Fabricate(:pod, name: 'Initial name')

      visit admin_pods_path
      click_link 'Initial name'
      fill_in 'Name', with: 'Edited name'
      click_button 'Update pod'
      expect(current_path).to eq(admin_pods_path)
      expect(page).to have_text('Edited name')
    end
  end

  describe "deleting a pod" do
    let!(:pod) { Fabricate(:pod, name: 'Save the Children') }

    it "should delete the pod" do
      visit edit_admin_pod_path(pod)
      click_button 'Delete'

      expect(current_path).to eq(admin_pods_path)
      expect(page).not_to have_content('Save the Children')
    end
  end

end
