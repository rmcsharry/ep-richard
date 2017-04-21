require "rails_helper"

RSpec.describe "the parents API", :type => :request do

  describe "parents dashboard" do

    it "returns no most recent comment notice when there are none for this parents pod" do
      game = Game.create!(name: "Test game", video_url: "https://minified.wistia.com/medias/q8x0tmoya2")

      pod1 = Pod.create!(name: "Pod 1")
      pod2 = Pod.create!(name: "Pod 2")
      
      parent1 = Parent.create!(name: "Richard", phone: "07963250340", pod: pod1)
      parent2 = Parent.create!(name: "Gerard", phone: "07963250340", pod: pod2)
      
      latest_comment = "This is the latest comment on pod2"
      comment = Comment.create!(body: latest_comment,   game: game, parent: parent2)

      get "api/parents/#{parent1.slug}"
      
      parent_response = json(response.body)[:parent]
      notice = parent_response[:pod_most_recent_comment_notice]
      
      expect(notice.as_json).to eq nil
    end

    it "returns the most recent comment notice for this pod when there is a comment" do
      game = Game.create!(name: "Test game", video_url: "https://minified.wistia.com/medias/q8x0tmoya2")

      pod1 = Pod.create!(name: "Pod 1")
      
      parent1 = Parent.create!(name: "Richard", phone: "07963250340", pod: pod1)
      parent2 = Parent.create!(name: "Gerard", phone: "07963250340", pod: pod1)

      latest_comment = "This is the latest comment"
      comment1 = Comment.create!(body: "Hello", game: game, parent: parent1)
      comment2 = Comment.create!(body: latest_comment, game: game, parent: parent2)
      get "api/parents/#{parent1.slug}"
      
      parent_response = json(response.body)[:parent]
      notice = parent_response[:pod_most_recent_comment_notice]
      
      expect(notice.as_json).to include("This is the latest comment")
      expect(notice.as_json).to include(comment2.parent_name)
    end
  end
  
end