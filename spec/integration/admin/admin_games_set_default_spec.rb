require "rails_helper"

RSpec.describe "setting games as default", :js => true, :type => :feature do

  before { login_as_admin }

  describe "setting a game as default" do
    let!(:parent) { Fabricate(:parent) }

    before do
      stub_get_video_from_wistia
      Fabricate(:game, name: 'Freeze')
    end

    it "only default games should show up for a parent" do
      visit new_admin_game_path
      fill_in 'Name', with: 'Hopscotch'
      fill_in 'Description', with: "Test"
      fill_in 'Instructions', with: "Test"
      fill_in 'Video URL', with: 'https://minified.wistia.com/medias/q8x0tmoya2'
      check('Add to default set')
      click_button 'Add game'
      
      Fabricate(:parent_visit_log, parent: parent) # fabricate a first visit so intro screens are not shown
      visit "/#/#{parent.slug}/games"

      expect(page).not_to have_content('Freeze')
      expect(page).to     have_content('Hopscotch')
    end
  end

end
