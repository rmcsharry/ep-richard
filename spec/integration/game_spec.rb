require "rails_helper"

RSpec.describe "viewing a game", js: true, :type => :feature do

  it "shows the game details" do
    Fabricate(:game, name:           "Freeze",
                     description:    "A game about staying still.",
                     instructions:   "Find some ice.",
                     image_url:      "/assets/poster.jpg",
                     video_embed_code: "<video></video>")

    visit '/'
    find(:css, '.games-list__game').click
    expect(page).to have_text("Freeze")
    expect(page).to have_text("A game about staying still.")
    expect(page).to have_text("Find some ice.")
    expect(page).to have_css("video")
  end

  it "renders Markdown to HTML" do
    Fabricate(:game, instructions: "# Heading")

    visit '/'
    find(:css, '.games-list__game').click
    expect(page).to have_css(".instructions h1")
  end

end
