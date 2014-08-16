require "rails_helper"

RSpec.describe "admin screens", :js => false, :type => :feature do

  describe "when accessing the admin index" do

    describe "if you're not logged in" do
      it "sends you to the login page" do
        visit '/admin'
        expect(current_path).to eq(admin_login_path)
        expect(page).to have_content "Sign in"
      end
    end

    describe "after logging in as EasyPeasy admin" do

      before { login_as_admin }

      it "takes you to the admin index" do
        expect(page).to have_content "EasyPeasy admin"
      end

      it "visiting directly takes you to the admin index" do
        visit '/admin'
        expect(page).to have_content "EasyPeasy admin"
      end

      it "logging out should redirect you to the login page" do
        visit '/admin'
        click_link 'Log out'
        expect(current_path).to eq(admin_login_path)
        expect(page).to have_content "Sign in"
      end

    end
  end
end
