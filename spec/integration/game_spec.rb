require "rails_helper"

RSpec.describe "viewing a game", js: true, :type => :feature do

  it "shows the game details" do
    Fabricate(:game, name:           "Freeze",
                     description:    "A game about staying still.",
                     image_url:      "/assets/poster.jpg",
                     video_embed_code: "<video></video>")

    visit '/'
    find(:css, '.games-list__game').click
    expect(page).to have_text("Freeze")
    expect(page).to have_text("A game about staying still.")
    expect(page).to have_css("video")
  end

end
