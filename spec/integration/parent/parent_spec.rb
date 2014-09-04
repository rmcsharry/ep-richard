require "rails_helper"

RSpec.describe "Parents", :js => true, :type => :feature do

  describe "accessing EasyPeasy as a parent" do
    let!(:parent) { Fabricate(:parent) }

    it "should show the games" do
      Fabricate(:game, name: "Game 1", description: "Game 1 desc")
      Fabricate(:game, name: "Game 2", description: "Game 2 desc")

      visit "/#/#{parent.id}/games"

      expect(page).to have_content('Game 1')
      expect(page).to have_content('Game 2')
    end

  end

end