require "rails_helper"

RSpec.describe "the parents API", :type => :request do

  describe "parents dashboard" do

    it "returns no latest comment when there are none" do
      game = Game.create!(name: "Test game", video_url: "https://minified.wistia.com/medias/q8x0tmoya2")

      pod1 = Pod.create!(name: "Pod 1")
      
      parent1 = Parent.create!(name: "Richard", phone: "07963250340", pod: pod1)
      parent2 = Parent.create!(name: "Gerard", phone: "07963250340", pod: pod1)

      get "api/parents/#{parent1.slug}"
      
      parent_response = json(response.body)[:parent]
      pod_latest_comment = parent_response[:pod_latest_comment]

      expect(pod_latest_comment.as_json).to eq nil
    end

    it "returns the latest comment from a parent in this pod" do
      game = Game.create!(name: "Test game", video_url: "https://minified.wistia.com/medias/q8x0tmoya2")

      pod1 = Pod.create!(name: "Pod 1")
      
      parent1 = Parent.create!(name: "Richard", phone: "07963250340", pod: pod1)
      parent2 = Parent.create!(name: "Gerard", phone: "07963250340", pod: pod1)

      latest_comment = "This is the latest comment"
      comment1 = Comment.create!(body: "Hello", game: game, parent: parent1)
      comment2 = Comment.create!(body: latest_comment,   game: game, parent: parent2)
      get "api/parents/#{parent1.slug}"
      
      parent_response = json(response.body)[:parent]
      pod_latest_comment = parent_response[:pod_latest_comment]

      expect(pod_latest_comment[:id].as_json).to eq comment2.id
    end
  end
  
end