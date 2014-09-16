require "rails_helper"

RSpec.describe "the list of games", :type => :feature do

  describe "viewing the list", js: true do
    let!(:parent) { Fabricate(:parent) }

    it "shows the games" do
      Fabricate(:game, name: "Game 1", description: "Game 1 desc", in_default_set: true)
      Fabricate(:game, name: "Game 2", description: "Game 2 desc", in_default_set: true)

      visit "/#/#{parent.slug}/games/"

      expect(page).to have_text("Game 1")
      expect(page).to have_text("Game 2")

      expect(page).to have_text("Game 1 desc")
      expect(page).to have_text("Game 2 desc")
    end

    it "shows the games in order with most recently added first" do
      Fabricate(:game, id: 2, name: "Bigger ID but older", created_at: Time.now - 1.day, in_default_set: true)
      Fabricate(:game, id: 1, name: "Smaller ID but newer", created_at: Time.now, in_default_set: true)

      visit "/#/#{parent.slug}/games/"
      expect(page).to have_selector("li.gameItem:nth-of-type(1)", text: "Smaller ID but newer")
      expect(page).to have_selector("li.gameItem:nth-of-type(2)", text: "Bigger ID but older")
    end

  end

end
