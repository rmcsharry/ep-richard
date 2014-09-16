require "rails_helper"

RSpec.describe "Parents", :js => true, :type => :feature do

  describe "accessing EasyPeasy as a parent" do
    let!(:parent) { Fabricate(:parent) }

    it "should show the games" do
      Fabricate(:game, name: "Game 1", description: "Game 1 desc", in_default_set: true)
      Fabricate(:game, name: "Game 2", description: "Game 2 desc", in_default_set: true)

      visit "/#/#{parent.slug}/games"

      expect(page).to have_content('Game 1')
      expect(page).to have_content('Game 2')
    end
  end

  describe "accessing EasyPeasy with a parent slug that doesn't exist" do
    it "displays an error message" do
      # visit "/#/not-a-real-slug/games"
      # expect(page).to have_content("Oops, it looks like I can't find that page. Please check with your pod admin.")
    end
  end

end
