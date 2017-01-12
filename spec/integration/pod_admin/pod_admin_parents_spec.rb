require "rails_helper"

RSpec.describe "Pod admin parents functionality", :js => false, :type => :feature do

  before { login_as_pod_admin }

  describe "adding a parent" do
    let!(:pod) { Fabricate(:pod) }
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
    let!(:parent) { Fabricate(:parent, name: 'Jen', pod: pod ) }

    before do
      visit pod_admin_parents_path
      click_link 'Add new parent'
      fill_in 'Name', with: 'Sam'
      fill_in 'Phone', with: '07515333333'
      click_button 'Add parent'
    end

    it "should add the parent" do
      parent = Parent.last
      expect(current_path).to eq(pod_admin_parent_path(parent))
      expect(page).to have_content('Sam')
      expect(page).not_to have_content('Jen')
    end

    it "should provide a URL for the parent" do
      parent = Parent.last
      expect(page).to have_content("/#/#{parent.slug}/games")
    end

    # describe "adding a parent with the same phone number as another" do
    #   it "should display an error" do
    #     visit pod_admin_parents_path
    #     click_link 'Add new parent'
    #     fill_in 'Name', with: 'Basil'
    #     fill_in 'Phone', with: '07515333333'
    #     click_button 'Add parent'
    #     expect(page).to have_content("Phone has already been taken")
    #   end
    # end

    # describe "editing a parent with the same phone number as another" do
    #   it "should display an error" do
    #     Fabricate(:parent, phone: '07111111111')
    #     visit pod_admin_parents_path
    #     click_link 'Sam'
    #     click_link 'Edit'
    #     fill_in 'Phone', with: '07111111111'
    #     click_button 'Update parent'
    #     expect(page).to have_content("Phone has already been taken")
    #   end
    # end

  end

  describe "import new parents functionality" do
    let!(:pod) { Fabricate(:pod, school_id: 'A1930499544') }
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }

    before do
      logout_admin
      login_as_specific_pod_admin(pod_admin)
    end

    describe "should show import functionality" do
      it "should show the functionality" do
        visit pod_admin_parents_path
        expect(page).to have_content('Import parents via your school SIMS')
        expect(page).to have_content('Children born after this date')
      end
    end
  end

  describe "editing and deleting a parent" do
    let!(:pod) { Fabricate(:pod) }
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
    let!(:parent) { Fabricate(:parent, name: 'Jen', phone: '07515444444', pod: pod ) }

    before do
      logout_admin
      login_as_specific_pod_admin(pod_admin)
    end

    describe "editing" do
      it "should update the parent" do
        visit pod_admin_parents_path
        click_link 'Jen'
        click_link 'Edit'
        fill_in 'Name', with: 'Sam'
        fill_in 'Phone', with: '07515333333'
        click_button 'Update parent'

        expect(page).not_to have_content('Basil')
        expect(page).to     have_content('Sam')
      end
    end

    describe "deleting a parent" do
      it "should delete the parent" do
        visit pod_admin_parents_path
        click_link 'Jen'
        click_link 'Edit'
        click_button 'Delete'

        within('.list-group') do
          expect(page).not_to have_content('Jen')
        end
      end
    end
  end

end
