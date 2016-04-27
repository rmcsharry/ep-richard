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

      it "clicking Games link should show all games, even those in the future and not in the default set" do
        click_link "Games"
        expect(page).to have_text("Game 1")
        expect(page).to have_text("Game 2")
        expect(page).to have_text("Game 3")
      end
      
      context "and pod is live" do
        before do
          pod.set_go_live_date
        end

        it "index should show there are no comments for the pod" do
          visit "/pod_admin"
          expect(page).to have_text("There are no comments on any of the games...yet!")
        end        
                
        it "index should show the latest comment for the pod if there is one" do
          game = Game.create!(name: "Game 1", description: "Game 1 desc", video_url: 'https://minified.wistia.com/medias/q8x0tmoya2', in_default_set: true)
          latest_comment = "This is the latest comment"
          Comment.create!(body: latest_comment, game: game, parent: parent)
          visit "/pod_admin"
          expect(page).to have_text(latest_comment)
        end        
      end # and pod is live
      
    end # when logged in
    
  end
end
