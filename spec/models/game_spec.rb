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
end