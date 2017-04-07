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
      expect(page).to have_content('EYFS Area')
      expect(page).to have_content('Learning Goal')      
    end
  end

  describe "adding a game" do
    it "adds a game to the admin page" do
      stub_get_video_from_wistia
      string = ""
      500.times { string += "x" }

      visit admin_games_path
      click_link 'Add new game'
      fill_in 'Name', with: 'Hopscotch'
      fill_in 'Description', with: string
      fill_in 'Instructions', with: string
      fill_in 'Video URL', with: 'https://minified.wistia.com/medias/q8x0tmoya2'
      select 'Mathematics', from: 'EYFS Area'
      select 'Speaking', from: 'Learning Goal'      
      click_button 'Add game'

      expect(current_path).to eq(admin_games_path)
      expect(page).to have_content('Hopscotch')

      click_link('Hopscotch')
      expect(page).to have_field("Name", with: "Hopscotch")
      expect(page).to have_field("Description", with: string)
      expect(page).to have_field("Instructions", with: string)
      expect(page).to have_field("Video URL", with: "https://minified.wistia.com/medias/q8x0tmoya2")
      expect(page).to have_field('EYFS Area', with: 'Mathematics')
      expect(page).to have_field('Learning Goal', with: 'Speaking')      
    end

    it "doesn't let you add a game without a name" do
      visit new_admin_game_path
      click_button 'Add game'
      expect(page).to have_text("error")

      fill_in 'Name', with: ' '
      click_button 'Add game'
      expect(Game.all.count).to eq(0)
    end

    it "doesn't let you add a game without a video URL" do
      visit new_admin_game_path
      fill_in 'Name', with: 'Test'
      fill_in 'Video URL', with: ' '
      click_button 'Add game'
      expect(page).to have_text("error")
    end

  end

  describe "editing a game" do
    let!(:game) { Fabricate(:game,
                            name: 'Freeze',
                            description: 'Stay cool',
                            instructions: 'Find some ice.',
                            video_url: 'https://minified.wistia.com/medias/q8x0tmoya2',
                            eyfs_area: 'Literacy',
                            eyfs_goal: 'Understanding') }

    it "shows the fields with the existing data in them" do
      visit admin_games_path
      click_link 'Freeze'
      game.save

      expect(page).to have_field('Name', with: 'Freeze')
      expect(page).to have_field('Description', with: 'Stay cool')
      expect(page).to have_field('Instructions', with: 'Find some ice.')
      expect(page).to have_field('Video URL', with: 'https://minified.wistia.com/medias/q8x0tmoya2')
      expect(page).to have_field('EYFS Area', with: 'Literacy')
      expect(page).to have_field('Learning Goal', with: 'Understanding')
    end

    it "updates the fields" do
      stub_get_video_from_wistia
      visit edit_admin_game_path(game)

      fill_in 'Name', with: 'Treasure Hunt'
      fill_in 'Description', with: 'Find the hidden treasure'
      fill_in 'Instructions', with: 'Create treasure.'
      select 'Mathematics', from: 'EYFS Area'
      select 'Speaking', from: 'Learning Goal'
      click_button 'Update game'

      expect(current_path).to eq(admin_games_path)
      expect(page).to have_content('Treasure Hunt')

      visit edit_admin_game_path(game)
      expect(page).to have_field('Description', with: 'Find the hidden treasure')
      expect(page).to have_field('Instructions', with: 'Create treasure.')
    end
  end

  describe "deleting a game" do
    let!(:game) { Fabricate(:game, name: 'Freeze') }

    it "deletes the game" do
      visit edit_admin_game_path(game)
      click_button "Delete"

      expect(current_path).to eq(admin_games_path)
      expect(page).not_to have_content('Freeze')
    end
  end

end
