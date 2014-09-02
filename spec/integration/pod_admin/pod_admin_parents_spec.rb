require "rails_helper"

RSpec.describe "Pod admin parents functionality", :js => false, :type => :feature do

  before { login_as_pod_admin }

  describe "adding a parent" do
    let!(:pod) { Fabricate(:pod) }
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
    let!(:parent) { Fabricate(:parent, name: 'Jen', pod: pod ) }

    it "should add the parent" do
      visit pod_admin_path
      click_link 'Add new parent'
      fill_in 'Name', with: 'Sam'
      fill_in 'Phone', with: '07515333333'
      click_button 'Add parent'

      expect(current_path).to eq(pod_admin_path)
      expect(page).to have_content('Sam')
      expect(page).not_to have_content('Jen')
    end

    it "shouldn't be possible to add two parents with the same phone number" do
      Fabricate(:parent, phone: '07515223234')
      expect { Fabricate(:parent, phone: '07515223234') }.to raise_error
    end
  end

  describe "editing a parent" do
    it "should update the parent" do

    end
  end

end
