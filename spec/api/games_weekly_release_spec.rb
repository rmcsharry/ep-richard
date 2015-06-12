require "rails_helper"

RSpec.describe "the games API", :type => :request do

  before do
    g1 = Game.create!(name: "Game 1", description: "Game 1 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', in_default_set: true)
    g2 = Game.create!(name: "Game 2", description: "Game 2 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2')
    g3 = Game.create!(name: "Game 3", description: "Game 3 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2')

    g1.position = 1
    g2.position = 2
    g3.position = 3

    g1.save && g2.save && g3.save
  end

  let(:pod1) { Fabricate(:pod) }
  let(:pod2) { Fabricate(:pod, go_live_date: Date.today) }
  let(:pod3) { Fabricate(:pod, go_live_date: Date.today - 1.week) }
  let(:pod4) { Fabricate(:pod, go_live_date: Date.today - 2.weeks) }
  let(:pod5) { Fabricate(:pod, go_live_date: Date.today - 10.weeks) }

  describe "a parent in a pod that's not live yet" do
    it "returns only games in the default set" do
      parent = Parent.create!(name: "Basil Safwat", phone: "07515333333", pod: pod1)
      get "/api/games?parent=#{parent.slug}"

      games = json(response.body)[:games]
      games = games.collect { |game| game[:name] }

      expect(games).to include("Game 1")
      expect(games).not_to include("Game 2")
      expect(games).not_to include("Game 3")
    end
  end

  describe "a parent in a pod that has been live < 1 week" do
    it "returns only games in the default set" do
      parent = Parent.create!(name: "Basil Safwat", phone: "07515333333", pod: pod2)
      get "/api/games?parent=#{parent.slug}"

      games = json(response.body)[:games]
      games = games.collect { |game| game[:name] }

      expect(games).to include("Game 1")
      expect(games).not_to include("Game 2")
      expect(games).not_to include("Game 3")
    end
  end

  describe "a pod that has been live 1 week" do
    it "returns 1 extra game" do
      parent = Parent.create!(name: "Basil Safwat", phone: "07515333333", pod: pod3)
      get "/api/games?parent=#{parent.slug}"

      games = json(response.body)[:games]
      games = games.collect { |game| game[:name] }

      expect(games).to     include("Game 1")
      expect(games).to     include("Game 2")
      expect(games).not_to include("Game 3")
    end
  end

  describe "a pod that has been live 2 weeks" do
    it "returns 2 extra games" do
      parent = Parent.create!(name: "Basil Safwat", phone: "07515333333", pod: pod4)
      get "/api/games?parent=#{parent.slug}"

      games = json(response.body)[:games]
      games = games.collect { |game| game[:name] }

      expect(games).to include("Game 1")
      expect(games).to include("Game 2")
      expect(games).to include("Game 3")
    end
  end

  describe "if there are more weeks than games" do
    it "returns all the extra games" do
      parent = Parent.create!(name: "Basil Safwat", phone: "07515333333", pod: pod5)
      get "/api/games?parent=#{parent.slug}"

      games = json(response.body)[:games]
      games = games.collect { |game| game[:name] }

      expect(games).to include("Game 1")
      expect(games).to include("Game 2")
      expect(games).to include("Game 3")
    end
  end

end
