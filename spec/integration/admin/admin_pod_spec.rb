require 'rails_helper'

RSpec.describe "EZY admin", :js => false, :type => :feature do

  before { login_as_admin }

  describe "creating a pod" do

    describe "when you don't supply a name" do
      it "should not create the pod" do
        visit admin_path
        click_link 'Pods'
        click_link 'Add new pod'
        click_button 'Add pod'

        expect(Pod.all.length).to eq(0)
        expect(page).to have_content("Name can't be blank")
      end

    end

    describe "when you do supply a name" do
      it "should create a pod (with test flag defaulting to false)" do
        expect(Pod.all.length).to eq(0)

        visit admin_path
        click_link 'Pods'
        click_link 'Add new pod'
        fill_in 'Name', with: 'Save the Children'
        click_button 'Add pod'

        expect(Pod.all.length).to eq(1)
        expect(Pod.last.is_test).to eq(false)
      end

      it "should show the pod on the pod index page" do
        Fabricate(:pod, name: 'Save the Children')
        Fabricate(:pod, name: 'Hackney Council')
        visit admin_pods_path

        expect(page).to have_content('Save the Children')
        expect(page).to have_content('Hackney Council')
      end
    end

    describe "when you supply a description" do
      before do
        visit admin_path
        click_link 'Pods'
        click_link 'Add new pod'
        fill_in 'Name', with: 'Save the Children'
        fill_in 'Description', with: 'Important pod for testing'
        click_button 'Add pod'
      end
      it "should add the pod" do
        expect(Pod.all.length).to eq(1)
        expect(Pod.all.first.description).to eq('Important pod for testing')
      end
      it "should show the description on the pod index page" do
        expect(page).to have_content('Save the Children')
        expect(page).to have_content('Important pod for testing')
        visit admin_pods_path
      end
    end
  end

  describe "editing a pod" do
    it "should allow changing the pod name" do
      Fabricate(:pod, name: 'Initial name')

      visit admin_pods_path
      click_link 'Initial name'
      fill_in 'Name', with: 'Edited name'
      click_button 'Update'
      expect(current_path).to eq(edit_admin_pod_path(1))
      expect(Pod.last.name).to eq('Edited name')
    end

    it "should allow setting the pod test flag to true" do
      Fabricate(:pod, name: 'Test pod', is_test: false)

      visit admin_pods_path
      click_link 'Test pod'
      check('pod_is_test')
      click_button 'Update'
      expect(current_path).to eq(edit_admin_pod_path(1))
      expect(Pod.last.is_test).to eq(true)
    end

    it "should allow setting the pod test flag to false" do
      Fabricate(:pod, name: 'Test pod', is_test: true)

      visit admin_pods_path
      click_link 'Test pod'
      uncheck('pod_is_test')
      click_button 'Update'
      expect(current_path).to eq(edit_admin_pod_path(1))
      expect(Pod.last.is_test).to eq(false)
    end

    it "should allow changing the pod go live date" do
      Fabricate(:pod, name: 'Test pod', go_live_date: '2016-01-01')

      visit admin_pods_path
      click_link 'Test pod'
      fill_in 'Go live date', with: '2016-01-07'
      click_button 'Update'
      expect(current_path).to eq(edit_admin_pod_path(1))
      expect(Pod.last.go_live_date).to eq('2016-01-07')
    end

    it "should allow changing the pod inactive date" do
      Fabricate(:pod, name: 'Test pod', inactive_date: '2016-01-07')

      visit admin_pods_path
      click_link 'Test pod'
      fill_in 'Inactive date', with: '2016-01-14'
      click_button 'Update'
      expect(current_path).to eq(edit_admin_pod_path(1))
      expect(Pod.last.inactive_date).to eq('2016-01-14')
    end

    it "should allow changing the school id" do
      Fabricate(:pod, name: 'Test pod', school_id: '')

      visit admin_pods_path
      click_link 'Test pod'
      fill_in 'School ID', with: 'A1930499544'
      click_button 'Update'
      expect(current_path).to eq(edit_admin_pod_path(1))
      expect(Pod.last.school_id).to eq('A1930499544')
    end

    it "should show import new parents functionality" do
      Fabricate(:pod, name: 'Test pod', school_id: '')

      visit admin_pods_path
      click_link 'Test pod'
      fill_in 'School ID', with: 'A1930499544'
      click_button 'Update'
      visit admin_pod_path(1)
      expect(page).to have_content('Import new parents via SIMS')
    end

  end

  describe "deleting a pod" do
    let!(:pod) { Fabricate(:pod, name: 'Save the Children') }

    it "should delete the pod" do
      visit edit_admin_pod_path(pod)
      click_link 'Delete'

      expect(current_path).to eq(admin_pods_path)
      expect(page).not_to have_content('Save the Children')
    end
  end

  describe "importing parents" do
    require 'csv'
    let!(:pod) { Fabricate(:pod, name: 'Import pod name') }
    let!(:parent) { Fabricate(:parent, pod: pod, phone: '07444007986') }

    it "should allow importing new parents" do
      visit edit_admin_pod_path(pod)

      attach_file('file', Rails.root.join('spec/fixtures/files/2_new_parents_test.csv'))
      click_button 'Import CSV'
      expect(page).to have_text("2 parents imported to #{pod.name}")
    end

    # it "should not allow import existing parents" do
    #   visit edit_admin_pod_path(pod)
    #
    #   attach_file('file', Rails.root.join('spec/fixtures/files/existing_parents_test.csv'))
    #   click_button 'Import CSV'
    #   expect(page).to have_text("0 parents imported to #{pod.name}")
    # end

    it "should detect not selecting a file" do
      visit edit_admin_pod_path(pod)

      click_button 'Import CSV'
      expect(page).to have_text("No file found - please select a CSV file.")
    end
  end

end
