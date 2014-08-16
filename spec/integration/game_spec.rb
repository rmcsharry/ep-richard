require "rails_helper"

RSpec.describe "viewing a game", js: true, :type => :feature do

  it "shows the game details" do
    Fabricate(:game, name: "Freeze", description: "A game about staying still.")

    visit '/'
    find(:css, '.games-list__game a').click
    expect(page).to have_text("Freeze")
    expect(page).to have_text("A game about staying still.")
  end

end
