require "rails_helper"

RSpec.describe "the games API", :type => :request do

  describe "listing games" do

    it "responds successfully with an HTTP 200 status code" do
      get '/api/games'
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the games" do
      Game.create!(name: "Game 1", description: "Game 1 desc")
      Game.create!(name: "Game 2", description: "Game 2 desc")

      get '/api/games'

      games = json(response.body)[:games]
      games = games.collect { |game| game[:name] }

      expect(games).to include("Game 1")
      expect(games).to include("Game 2")
    end
  end

  describe "getting a single game" do
    it "returns the game" do
      game = Game.create!(name: "Game 1", description: "Game 1 desc")
      get "/api/games/#{game.id}"

      expect(response).to be_success
      expect(response).to have_http_status(200)

      game_response = json(response.body)[:game]
      expect(game_response[:name]).to eq("Game 1")
    end
  end

end
