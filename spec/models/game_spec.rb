require 'rails_helper'

RSpec.describe Game, :type => :model do

  describe "the video url" do

    describe "entering an invalid URL" do
      it "should be invalid" do
        g = Game.new
        g.name = "Basil test"
        g.video_url = "https://google.com"
        expect(g.valid?).to eq(false)
      end
    end

    describe "entering an valid URL" do
      it "should be valid" do
        g = Game.new
        g.name = "Basil test"
        g.video_url = "https://minified.wistia.com/medias/q8x0tmoya2"
        expect(g.valid?).to eq(true)
      end
    end
  end

  describe "position" do
    let!(:game1) { Fabricate(:game, position: 1) }
    let!(:game2) { Fabricate(:game, position: 2) }

    it "adds new games with the highest position" do
      g = Fabricate(:game)
      expect(g.position).to eq(1)
    end
  end

  describe "parents played" do
    let(:pod) { Fabricate(:pod)}
    let(:game) { Fabricate(:game)}
    
    context "when no parents have visited" do
      it "returns nil for parents played" do
        expect(game.parents_played(pod.id)).to eq(nil)
      end
    end

    context "when 3 parents have visited" do
      let(:parentA) { Fabricate(:parent, pod: pod) }
      let(:parentB) { Fabricate(:parent, pod: pod) }
      let(:parentC) { Fabricate(:parent, pod: pod) }

      it "returns correct text for parents played" do
        pod.go_live_date = Date.today - 7.days
        parentB.name = 'Mickey Mouse'
        parentB.save
        log_a_visit(parentA, pod, game)
        log_a_visit(parentB, pod, game)
        log_a_visit(parentC, pod, game)
        expect(game.parents_played(pod.id)).to eq("Basil, Mickey and 1 other parent have played this game.")
      end
    end

    context "when 4 parents have visited" do
      let(:parentA) { Fabricate(:parent, pod: pod) }
      let(:parentB) { Fabricate(:parent, pod: pod) }
      let(:parentC) { Fabricate(:parent, pod: pod) }
      let(:parentD) { Fabricate(:parent, pod: pod) }

      it "returns correct text for parents played" do
        pod.go_live_date = Date.today - 7.days
        parentB.name = 'Mickey Mouse'
        parentB.save
        log_a_visit(parentA, pod, game)
        log_a_visit(parentB, pod, game)
        log_a_visit(parentC, pod, game)
        log_a_visit(parentD, pod, game)
        expect(game.parents_played(pod.id)).to eq("Basil, Mickey and 2 other parents have played this game.")
      end
    end
  end

end
