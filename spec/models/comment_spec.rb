require 'rails_helper'

RSpec.describe Comment, :type => :model do

  describe "a comment" do
    let!(:parent) { Fabricate(:parent) }

    it "requires a body and a parent" do
      c = Comment.new
      expect(c.valid?).to eq(false)
      c.body = "Hello"
      expect(c.valid?).to eq(false)
      c.parent = parent
      expect(c.valid?).to eq(true)
    end
  end

  describe "comments" do
    let!(:game)     { Fabricate(:game, name: "Test game", video_url: "https://minified.wistia.com/medias/q8x0tmoya2") }
    
    let!(:pod1)     { Fabricate(:pod, name: "Pod 1") }
    let!(:parent1)  { Fabricate(:parent, name:"Basil", phone: "07515222222", pod: pod1) }
    let!(:comment1) { Fabricate(:comment, body: "First comment", game: game, parent: parent1) }
    
    let!(:pod2)     { Fabricate(:pod, name: "Pod 2") }
    let!(:parent2)  { Fabricate(:parent, name:"Sam", phone: "07515333333", pod: pod2) }
    let!(:comment2) { Fabricate(:comment, body: "Second comment", game: game, parent: parent2) }
    
    context "game method comments_for_pod" do
      it "returns only the comments made by people in the specified pod" do
        comments_for_pod_1 = game.comments_for_pod(pod1.id)
        comments_for_pod_2 = game.comments_for_pod(pod2.id)

        expect(comments_for_pod_1.length).to eq(1)
        expect(comments_for_pod_2.length).to eq(1)

        expect(comments_for_pod_1).not_to include(comment2)
        expect(comments_for_pod_2).not_to include(comment1)
      end
      
      it "returns comments for the pod in reverse created order" do
        parent3 = Parent.create!(name: "Richard", phone: "07433107777", pod: pod1)
        comment3 = Comment.create!(body: "Third comment", game: game, parent: parent3)
        
        expect(game.comments_for_pod(pod1.id)).not_to include(comment2)
        expect(game.comments_for_pod(pod1.id)).not_to eq([comment1,comment3])
        expect(game.comments_for_pod(pod1.id)).to eq([comment3,comment1])
      end
    end

    context "deleting a parent" do
      it "also deletes the parent's comments" do
        expect(Comment.all.length).to eq(2)
        parent1.destroy
        expect(Comment.all.length).to eq(1)
      end
    end
  end
end
