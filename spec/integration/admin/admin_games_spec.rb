require "rails_helper"

RSpec.describe "admin games", :js => false, :type => :feature do

  before { login_as_admin }

  describe "viewing games" do

    before do
      Fabricate(:game, name: 'Freeze')
      Fabricate(:game, name: 'Treasure Hunt')
    end

    it "should show you a list of games" do
      visit admin_games_path
      expect(page).to have_content('Freeze')
      expect(page).to have_content('Treasure Hunt')
    end
  end

  describe "adding a game" do
    it "adds a game to the admin page" do
      visit admin_games_path
      click_link 'Add new game'
      fill_in 'Name', with: 'Hopscotch'
      click_button 'Add game'

      expect(current_path).to eq(admin_games_path)
      expect(page).to have_content('Hopscotch')
    end
  end

  describe "editing a game" do
    let!(:game) { Fabricate(:game, name: 'Freeze') }

    it "shows the fields with the existing data in them" do
      visit admin_games_path
      click_link 'Freeze'

      expect(page).to have_field("Name", with: "Freeze")
    end

    it "updates the name" do
      visit edit_admin_game_path(game)

      fill_in 'Name', with: 'Treasure Hunt'
      click_button 'Update game'

      expect(current_path).to eq(admin_games_path)
      expect(page).to have_content('Treasure Hunt')
    end
  end

  describe "deleting a game" do
    let!(:game) { Fabricate(:game, name: 'Freeze') }

    it "deletes the game" do
      visit edit_admin_game_path(game)
      click_button "Delete game"

      expect(current_path).to eq(admin_games_path)
      expect(page).not_to have_content('Freeze')
    end
  end

end
