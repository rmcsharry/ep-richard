require "rails_helper"

RSpec.describe "the list of games", :type => :feature do

  describe "viewing the list", js: true do

    it "shows the games" do
      Game.create!(name: "Game 1", description: "Game 1 desc")
      Game.create!(name: "Game 2", description: "Game 2 desc")

      p Game.all

      visit '/'
      show_me_the_page

      expect(page).to have_text("Game 1")
      expect(page).to have_text("Game 2")
    end
  end

end
