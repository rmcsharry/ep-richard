require "rails_helper"

RSpec.describe "Authorisation", :js => false, :type => :feature do

  describe "pod admin" do
    before { login_as_pod_admin }

    describe "when accessing the admin screens" do
      it "should only be able to see certain links" do
        expect(page).not_to have_link('Pods')
        expect(page).not_to have_link('Pod admins')
        expect(page).to     have_text('Parents')
      end

      it "should not be able to access EZY admin urls directly" do
        visit admin_pods_path
        expect(current_path).to eq(pod_admin_path)

        visit admin_games_path
        expect(current_path).to eq(pod_admin_path)

        visit admin_pod_admins_path
        expect(current_path).to eq(pod_admin_path)
      end
    end
  end

end
