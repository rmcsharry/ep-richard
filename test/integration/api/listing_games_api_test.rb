require 'test_helper'

class ListingGamesAPITest < ActionDispatch::IntegrationTest

  test 'returns list of all games' do
    Game.create!(name: "Game 1", description: "Game 1 desc")
    Game.create!(name: "Game 2", description: "Game 2 desc")

    get '/api/games'
    assert_equal 200, response.status

    games = json(response.body)[:games]
    games = games.collect { |game| game[:name] }

    assert_includes games, "Game 1"
    assert_includes games, "Game 2"
  end

end
