require "rails_helper"

RSpec.describe "Games List", :js => false, :type => :feature do

  describe "the pod admin games list" do

    let!(:pod)       { Fabricate(:pod) }
    let!(:pod_admin) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
    let!(:parent)    { Fabricate(:parent, name: 'Jen', phone: '07515444444', pod: pod ) }
    
    before do
      Fabricate(:game, name: "Game 1", description: "Game 1 desc", in_default_set: true) 
      Fabricate(:game, name: "Game 2", description: "Game 2 desc", in_default_set: false)
      Fabricate(:game, name: "Game 3", description: "Game 3 desc", in_default_set: false)
    end

    describe "when not logged in" do
      it "should not have a link to the games list in the header" do
        visit "/admin"
        expect(page).not_to have_link("Games")
      end
    end

    describe "when logged in" do
      before do
        login_as_specific_pod_admin(pod_admin)
      end

      it "should have a link to the games list in the header" do
        expect(page).to have_link("Games")
      end
      
      context "and pod is live" do
        before do
          pod.go_live_date = Date.today - 8.days # puts us in week 1
          pod.save
        end

        it "clicking Games link should show all games, even those in the future and not in the default set" do
          click_link "Games"
          sleep 4
          screenshot
          expect(page).to have_text("Game 1")
          expect(page).to have_text("Game 2")
          expect(page).to have_text("Game 3")
        end

        it "clicking Games link should show the eyfs fields" do
          eyfs_goal = "Testing eyfs goal"
          eyfs_area = "Testing eyfs area"
          game = Game.create!(
                  name: "Game 4", 
                  description: "Game 1 desc", 
                  video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', 
                  position: 1, 
                  in_default_set: false,
                  eyfs_goal: eyfs_goal,
                  eyfs_area: eyfs_area)
          click_link "Games"
          expect(page).to have_text(eyfs_goal)
          expect(page).to have_text(eyfs_area)
        end

        it "index should show there are no comments for the pod" do
          visit "/pod_admin"
          expect(page).to have_text("This week's game is out! Be the first to comment!")
        end        
                
        it "index should show the latest comment for the pod if there is one" do
          game = Game.create!(name: "Game 1", description: "Game 1 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', in_default_set: true)
          latest_comment = "This is the latest comment"
          Comment.create!(body: latest_comment, game: game, parent: parent)
          visit "/pod_admin"
          expect(page).to have_text(latest_comment)
        end
        
        it "index should show eyfs fields" do
          eyfs_goal = "Testing eyfs goal"
          eyfs_area = "Testing eyfs area"
          game = Game.create!(
                  name: "Game 1", 
                  description: "Game 1 desc", 
                  video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', 
                  position: 1, 
                  in_default_set: false,
                  eyfs_goal: eyfs_goal,
                  eyfs_area: eyfs_area)
          
          visit "/pod_admin"
          expect(page).to have_text(eyfs_goal)
          expect(page).to have_text(eyfs_area)
        end
      end # and pod is live
      
    end # when logged in
    
  end
end
