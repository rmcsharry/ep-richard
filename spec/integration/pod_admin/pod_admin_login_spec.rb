require "rails_helper"

RSpec.describe "Pod admin", :js => false, :type => :feature do
  
  describe "logging in as a pod admin" do

    let!(:pod_admin) { Fabricate(:pod_admin, email: 'bsafwat+1@gmail.com', password: 'Password1' ) }

    it "should let you log in" do
      visit admin_login_path
      fill_in 'Email', with: pod_admin.email
      fill_in 'Password', with: pod_admin.password
      click_button 'Sign in'
      expect(page).to have_content('Signed in successfully')
    end

    describe "if your pod was deleted" do
      let!(:pod_admin) { Fabricate(:pod_admin, email: 'bsafwat+1@gmail.com', password: 'Password1' ) }

      it "should throw an error" do
        Pod.last.destroy

        visit admin_login_path
        fill_in 'Email', with: pod_admin.email
        fill_in 'Password', with: pod_admin.password
        click_button 'Sign in'
        
        expect(page).to have_content("Hm. I can't find your pod. Please contact a member of EasyPeasy staff to sort this out. Sorry for the inconvenience.")
      end

    end
  end

end
