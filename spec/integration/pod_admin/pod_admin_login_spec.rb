require "rails_helper"

RSpec.describe "EZY admin", :js => false, :type => :feature do
  
  describe "logging in as a pod admin" do

    let!(:pod_admin) { Fabricate(:pod_admin, email: 'bsafwat+1@gmail.com', password: 'Password1' ) }

    it "should let you log in" do
      visit admin_login_path
      fill_in 'Email', with: pod_admin.email
      fill_in 'Password', with: pod_admin.password
      click_button 'Sign in'
      expect(page).to have_content('Signed in successfully')
    end
  end

end
