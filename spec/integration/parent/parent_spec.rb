require "rails_helper"

RSpec.describe "Parents", :js => true, :type => :feature do

  describe "accessing EasyPeasy as a parent" do
    let!(:parent) { Fabricate(:parent) }

    before do
      Fabricate(:game, name: "Game 1", description: "Game 1 desc", in_default_set: true)
      Fabricate(:game, name: "Game 2", description: "Game 2 desc", in_default_set: true)
    end

    context "for the first time" do
      it "should show the welcome intro screen" do
        visit "/#/#{parent.slug}/games"
        expect(page).to have_content('Welcome to EasyPeasy!')
        expect(page).to have_content('with EasyPeasy, playing together helps your child develop key skills for school and life.')
        # Note: do not try clicking the screen to check if the 2nd and 3rd intro screens load, Capybara fails to detect Ember component changes
      end

    end

    context "after the first time" do
      before do
        Fabricate(:parent_visit_log, parent: parent) # fabricate a first visit so intro screens are not shown
        visit "/#/#{parent.slug}/games"
      end

      it "should show the games" do
        expect(page).to have_content('Game 1')
        expect(page).to have_content('Game 2')
      end

      it "should not see the CTA to comment" do
        expect(page).not_to have_content("This week's game is out! Be the first to comment!")
      end
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
      Fabricate(:parent_visit_log, parent: parent) # fabricate a first visit so intro screens are not shown
    end

    let!(:game) { Fabricate(:game, name: "Game 1", description: "Game 1 desc", in_default_set: true) }
    let(:pod) { Fabricate(:pod, go_live_date: Date.today - 1.week) }
    let!(:parent) { Fabricate(:parent, pod: pod) }
    let!(:parent2) { Fabricate(:parent, pod: pod) }

    it "should show them 1 extra game" do
      visit "/#/#{parent.slug}/games"
      expect(page).to have_content('Game 1')
      expect(page).to have_content('Game 2')
    end

    it "should not see the CTA to comment" do
      visit "/#/#{parent.slug}/games"
      expect(page).not_to have_content("This week's game is out! Be the first to comment!")
    end

    it "should show the latest comment from another parent in the same pod" do
      latest_comment = 'Here is another parents latest comment'
      comment = Fabricate(:comment, body: latest_comment, parent: parent2, game: game)
      visit "/#/#{parent.slug}/games"
      expect(page).to have_content("The most recent comment was from #{comment.parent_name}")
      expect(page).to have_content(latest_comment)
    end
  end

  describe "after the first non-default game is released (ie. after week 1 has begun)" do
    before do
      Game.create!(name: "Game 1", description: "Game 1 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', in_default_set: true)
      Game.create!(name: "Game 2", description: "Game 2 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', created_at: 1.day.ago)
      Fabricate(:parent_visit_log, parent: parent) # fabricate a first visit so intro screens are not shown
    end

    let!(:game) { Fabricate(:game, name: "Game Non Default", description: "Game Non Default desc", in_default_set: false) }
    let(:pod) { Fabricate(:pod, go_live_date: Date.today - 8.days) }
    let!(:parent) { Fabricate(:parent, pod: pod) }
    
    it "should show the CTA to comment" do
      visit "/#/#{parent.slug}/games"
      expect(page).to have_content("This week's game is out! Be the first to comment!")      
    end
  end

end
