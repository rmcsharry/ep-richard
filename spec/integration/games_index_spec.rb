require "rails_helper"

RSpec.describe "the list of games", :type => :feature do

  describe "viewing the list", js: true do
    let!(:parent) { Fabricate(:parent) }

    it "shows the games" do
      Fabricate(:game, name: "Game 1", description: "Game 1 desc")
      Fabricate(:game, name: "Game 2", description: "Game 2 desc")

      visit "/#/#{parent.id}/games/"

      expect(page).to have_text("Game 1")
      expect(page).to have_text("Game 2")

      expect(page).to have_text("Game 1 desc")
      expect(page).to have_text("Game 2 desc")
    end
  end

end
