require "rails_helper"

RSpec.describe "Pod admin parents functionality", :js => false, :type => :feature do

  before { login_as_pod_admin }

  describe "adding a parent" do
    it "should add the parent" do
      visit pod_admin_path
      click_link 'Add new parent'
      fill_in 'Name', with: 'Sam'
      fill_in 'Phone', with: '07515333333'
      click_button 'Add parent'

      expect(Parent.all.count).to eq(1)
      expect(current_path).to eq(pod_admin_path)
      expect(page).to have_content('Sam')
    end

    it "shouldn't be possible to add two parents with the same phone number" do
      Fabricate(:parent, phone: '07515223234')
      expect { Fabricate(:parent, phone: '07515223234') }.to raise_error
    end

  end

end
