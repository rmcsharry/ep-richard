require "rails_helper"

RSpec.describe "admin games bugs", :js => false, :type => :feature do

  before { login_as_admin }

  describe "getting a blank response from Wistia when requesting game details" do
    it "it displays an error message with debug info" do
      stub_request(:get, "http://fast.wistia.com/oembed?url=https://minified.wistia.com/medias/q8x0tmoya2?videoFoam=true").
        to_return(:status => 200, :body => " ", :headers => {})
      visit admin_games_path
      click_link 'Add new game'
      fill_in 'Name', with: 'Hopscotch'
      fill_in 'Description', with: "Description"
      fill_in 'Instructions', with: "Instructions"
      fill_in 'Video URL', with: 'https://minified.wistia.com/medias/q8x0tmoya2'
      click_button 'Add game'

      expect(page).to have_content('Oops. An error occured while talking to Wistia.')
    end
  end

end
