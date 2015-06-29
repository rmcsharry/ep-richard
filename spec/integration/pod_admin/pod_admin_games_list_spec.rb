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

      it "clicking should show all games, even those in the future and not in the default set" do
        click_link "Games"
        expect(page).to have_text("Game 1")
        expect(page).to have_text("Game 2")
        expect(page).to have_text("Game 3")
      end
    end

  end
end
