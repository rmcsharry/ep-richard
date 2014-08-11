require 'test_helper'

class ListingGamesTest < ActionDispatch::IntegrationTest

  test 'shows a list of all games' do
    Game.create!(name: "Freeze")
    Game.create!(name: "Treasure Hunt")

    get '/'
    assert_equal 200, response.status

    assert_includes response.body, "Freeze"
    assert_includes response.body, "Treasure Hunt"
  end

end
