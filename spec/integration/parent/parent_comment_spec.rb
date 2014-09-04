require "rails_helper"

RSpec.describe "Comments", :js => true, :type => :feature do
  let!(:pod){ Fabricate(:pod) }
  let!(:parent){ Fabricate(:parent, pod: pod) }
  let!(:game){ Fabricate(:game) }
  let!(:comment){ Fabricate(:comment, body: 'Here is my comment', parent: parent, game: game) }

  before do
    visit "/#/#{parent.id}/games/"
    find(:css, '.games-list__game').click
  end

  describe "accessing the comments page for a game" do
    it "should display the comments page for the game" do
      click_link 'Comments'
      expect(page).to have_content('Here is my comment')
    end
  end

  describe "adding a comment" do
    it "should show the comment after you add it" do
      click_link 'Comments'
      fill_in 'comment', with: 'This was a great game.'
      click_button 'Add comment'
    end
  end

  describe "viewing commments" do
    it "should show you comments only from other members of your pod"
  end

end
