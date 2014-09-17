require "rails_helper"

RSpec.describe "viewing a game", js: true, :type => :feature do
  let!(:parent) { Fabricate(:parent) }

  it "shows the game details" do
    Fabricate(:game, name:           "Freeze",
                     description:    "A game about staying still.",
                     instructions:   "Find some ice.",
                     in_default_set: true
             )

    visit "/#/#{parent.slug}/games/"
    find(:css, '.gameItem').click
    expect(page).to have_text("Freeze")
    expect(page).to have_text("Find some ice.")
    expect(page).to have_css("iframe")
  end

  it "renders Markdown to HTML" do
    Fabricate(:game, instructions: "# Heading", in_default_set: true)

    visit "/#/#{parent.slug}/games/"
    find(:css, '.gameItem').click
    expect(page).to have_css(".markdownInstructions h1")
  end

  describe "[bug] viewing two games" do
    let!(:game1) { Fabricate(:game, video_url: 'https://minified.wistia.com/medias/example', in_default_set: true) }
    let!(:game2) { Fabricate(:game, video_url: 'https://minified.wistia.com/medias/test', in_default_set: true) }
    it "correctly changes the src of the iframe" do
      visit "/#/#{parent.slug}/game/#{game1.id}"
      expect(find('iframe')[:src]).to have_text('example')
      visit "/#/#{parent.slug}/game/#{game2.id}"
      expect(find('iframe')[:src]).to have_text('test')
    end
  end

end
