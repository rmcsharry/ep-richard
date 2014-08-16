require "rails_helper"

RSpec.describe "viewing a game", js: true, :type => :feature do

  it "shows the game details" do
    Fabricate(:game, name: "Freeze",
                     description: "A game about staying still.",
                     video_url_mp4: "/assets/test.mp4",
                     video_url_webm: "/assets/test.webm")

    visit '/'
    find(:css, '.games-list__game a').click
    expect(page).to have_text("Freeze")
    expect(page).to have_text("A game about staying still.")
    expect(page).to have_css("video")
    expect(page).to have_xpath("//source[@src='/assets/test.mp4']")
    expect(page).to have_xpath("//source[@src='/assets/test.webm']")
  end

end
