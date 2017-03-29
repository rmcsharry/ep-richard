require "rails_helper"

RSpec.describe "EZY admin", :js => false, :type => :feature do

  before { login_as_admin }

  describe "listing the pod admins" do
    before do
      Fabricate(:pod_admin, email: 'esteban+1@easypeasyapp.com')
      Fabricate(:pod_admin, email: 'esteban+2@easypeasyapp.com')
    end

    it "should list all pod admins" do
      visit admin_pod_admins_path
      expect(page).to have_content('esteban+1@easypeasyapp.com')
      expect(page).to have_content('esteban+2@easypeasyapp.com')
    end
  end

  describe "creating a pod admin" do
    describe "when there are no pods" do
      it "should ask you to create a pod first" do
        visit admin_path
        click_link 'Pod admins'
        click_link 'Add new pod'

        expect(page).to have_content("You need to add a pod")
      end
    end

    describe "when there is a pod" do
      before do
        Fabricate(:pod, name: 'Save the Children')
        visit admin_path
        click_link 'Pod admins'
        click_link 'Add new pod'
      end

      describe "when you don't select a pod" do
        it "should give you a validation error" do
          fill_in 'Email', with: 'esteban+podadmin@easypeasyapp.com'
          fill_in 'Preferred name', with: 'basil'
          click_button 'Add pod admin'

          expect(page).to have_content("Pod can't be blank")
          expect(PodAdmin.all.count).to eq(0)
        end
      end

      describe "when you select a pod" do
        it "should create a pod admin" do
          expect(PodAdmin.all.count).to eq(0)

          fill_in 'Email', with: 'esteban+podadmin@easypeasyapp.com'
          fill_in 'Preferred name', with: 'Basil'
          select('Save the Children', :from => 'pod_admin_pod_id')
          click_button 'Add pod admin'

          expect(PodAdmin.all.count).to eq(1)
          expect(PodAdmin.last.pod.name).to eq('Save the Children')
        end
      end

      describe "when you don't provide a preferred name" do
        it "should give you a validation error" do
          fill_in 'Email', with: 'esteban+podadmin@easypeasyapp.com'
          select('Save the Children', :from => 'pod_admin_pod_id')
          click_button 'Add pod admin'

          expect(page).to have_content("Preferred name can't be blank")
          expect(PodAdmin.all.count).to eq(0)
        end
      end

    end
  end

  describe "editing a pod admin" do
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'esteban+1@easypeasyapp.com', password: 'Password1') }

    it "lets you edit the pod admin's email" do
      visit admin_pod_admins_path
      click_link 'esteban+1@easypeasyapp.com'
      fill_in 'Email', with: 'esteban+2@easypeasyapp.com'

      click_button 'Update'
      visit admin_pod_admins_path

      expect(page).not_to have_text('esteban+1@easypeasyapp.com')
      expect(page).to     have_text('esteban+2@easypeasyapp.com')
    end
  end

  describe "deleting a pod admin" do
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'esteban+deleteme@easypeasyapp.com') }

    it "deletes the pod admin" do
      visit edit_admin_pod_admin_path(pod_admin)
      click_link "Delete"

      expect(current_path).to eq(admin_pod_admins_path)
      expect(page).not_to have_content('esteban@easypeasyapp.com')
    end
  end

end
