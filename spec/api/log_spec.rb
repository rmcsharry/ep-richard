require "rails_helper"

RSpec.describe "the logging API", :type => :request do

  let!(:pod)        { Fabricate(:pod, name: 'Brockley Pod') }
  let!(:parent1)    { Fabricate(:parent, name: 'Jen', phone: '07515444444', pod: pod ) }
  let!(:game1)      { Fabricate(:game, name: "Game 1", description: "Game 1 desc", in_default_set: true) }

  describe "logging a visit" do

    it "returns a 200" do
      post '/api/log'
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "logs a visit to the games/index page" do
      params = { location: "/#{parent1.slug}/games" }
      post '/api/log', params
      expect(ParentVisitLog.count).to eq(1)
      expect(ParentVisitLog.first.parent_id).to eq(parent1.id)
    end

    it "logs a visit to a game page" do
      params = { location: "/#{parent1.slug}/game/#{game1.id}" }
      post '/api/log', params
      expect(ParentVisitLog.count).to eq(1)
      expect(ParentVisitLog.first.game_id).to eq(game1.id)
    end

    it "doesn't log a visit if the parent_id doesn't exist" do
      params = { location: "/doesnt_exist/game/#{game1.id}" }
      post '/api/log', params
      expect(ParentVisitLog.count).to eq(0)
    end

    it "doesn't log a visit if the game_id doesn't exist" do
      params = { location: "/#{parent1.slug}/game/0" }
      post '/api/log', params
      expect(ParentVisitLog.count).to eq(0)
    end
  end

end
