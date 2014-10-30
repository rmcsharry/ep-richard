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

  describe "accessing a week after the go live date" do

    before do
      Game.create!(name: "Game 1", description: "Game 1 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', in_default_set: true)
      Game.create!(name: "Game 2", description: "Game 2 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', created_at: 1.day.ago)
    end

    let(:pod) { Fabricate(:pod, go_live_date: Date.today - 1.week) }
    let!(:parent) { Fabricate(:parent, pod: pod) }

    it "should show them 1 extra game" do
      visit "/#/#{parent.slug}/games"
      expect(page).to have_content('Game 1')
      expect(page).to have_content('Game 2')
    end
  end

end
