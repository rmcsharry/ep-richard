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

  describe "comments_for_pod" do
    it "returns only the comments made by people in the specified pod" do
      game = Game.create!(name: "Test game", video_url: "https://minified.wistia.com/medias/q8x0tmoya2")

      pod1 = Pod.create!(name: "Pod 1")
      parent1 = Parent.create!(name: "Basil", phone: "07515222222", pod: pod1)

      pod2 = Pod.create!(name: "Pod 2")
      parent2 = Parent.create!(name: "Sam", phone: "07515333333", pod: pod2)

      comment1 = Comment.create!(body: "Hello", game: game, parent: parent1)
      comment2 = Comment.create!(body: "Hey",   game: game, parent: parent2)

      comments_for_pod_1 = game.comments_for_pod(pod1.id)
      comments_for_pod_2 = game.comments_for_pod(pod2.id)

      expect(comments_for_pod_1.length).to eq(1)
      expect(comments_for_pod_2.length).to eq(1)

      expect(comments_for_pod_1).not_to include(comment2)
      expect(comments_for_pod_2).not_to include(comment1)
    end
  end

  describe "deleting a parent" do
    it "deletes the parent's comments" do
      game = Game.create!(name: "Test game", video_url: "https://minified.wistia.com/medias/q8x0tmoya2")
      pod = Pod.create!(name: "Pod 1")
      parent = Parent.create!(name: "Basil", phone: "07515222222", pod: pod)
      parent2 = Parent.create!(name: "Sam", phone: "07515333333", pod: pod)
      Comment.create!(body: "Hello", game: game, parent: parent)
      Comment.create!(body: "Hey",   game: game, parent: parent2)

      expect(Comment.all.length).to eq(2)
      parent.destroy
      expect(Comment.all.length).to eq(1)
    end
  end

end
