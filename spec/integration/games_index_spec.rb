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

    it "shows the games in order of position" do
      pod = Fabricate(:pod, go_live_date: Date.today - 1.week)
      parent = Fabricate(:parent, pod: pod)

      a = Fabricate(:game, name: "Position 4", in_default_set: true)
      b = Fabricate(:game, name: "Position 1", in_default_set: true)
      c = Fabricate(:game, name: "Position 3", in_default_set: true)
      d = Fabricate(:game, name: "Position 2", in_default_set: true)

      a.position = 4
      b.position = 1
      c.position = 3
      d.position = 2

      a.save
      b.save
      c.save
      d.save

      visit "/#/#{parent.slug}/games/"
      expect(page).to have_selector("li.gameItem:nth-of-type(1)", text: "Position 1")
      expect(page).to have_selector("li.gameItem:nth-of-type(2)", text: "Position 2")
      expect(page).to have_selector("li.gameItem:nth-of-type(3)", text: "Position 3")
      expect(page).to have_selector("li.gameItem:nth-of-type(4)", text: "Position 4")
    end

    it "shows the default games under the non default games, no matter the position" do
      pod = Fabricate(:pod, go_live_date: Date.today - 1.week)
      parent_in_old_pod = Fabricate(:parent, pod: pod)

      Fabricate(:game, name: "Default and higher position", position: 1, in_default_set: true)
      Fabricate(:game, name: "Not default and lower position", position: 2, in_default_set: false)

      visit "/#/#{parent_in_old_pod.slug}/games/"
      expect(page).to have_selector("li.gameItem:nth-of-type(1)", text: "Not default and lower position")
      expect(page).to have_selector("li.gameItem:nth-of-type(2)", text: "Default and higher position")
    end

  end

end
