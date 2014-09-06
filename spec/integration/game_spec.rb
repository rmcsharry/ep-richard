require "rails_helper"

RSpec.describe "viewing a game", js: true, :type => :feature do
  let!(:parent) { Fabricate(:parent) }

  it "shows the game details" do
    Fabricate(:game, name:           "Freeze",
                     description:    "A game about staying still.",
                     instructions:   "Find some ice.",
             )

    visit "/#/#{parent.id}/games/"
    find(:css, '.gameItem').click
    expect(page).to have_text("Freeze")
    expect(page).to have_text("Find some ice.")
    expect(page).to have_css("iframe")
  end

  it "renders Markdown to HTML" do
    Fabricate(:game, instructions: "# Heading")

    visit "/#/#{parent.id}/games/"
    find(:css, '.gameItem').click
    expect(page).to have_css(".markdownInstructions h1")
  end

end
