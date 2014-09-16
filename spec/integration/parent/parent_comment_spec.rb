require "rails_helper"

RSpec.describe "Comments", :js => true, :type => :feature do
  let!(:pod){ Fabricate(:pod) }
  let!(:parent){ Fabricate(:parent, name: 'Basil Safwat', phone: '07515333333', pod: pod) }
  let!(:parent2){ Fabricate(:parent, name: 'Bob Smith', pod: pod) }

  let!(:game){ Fabricate(:game) }
  let!(:comment){ Fabricate(:comment, body: 'Here is my comment', parent: parent, game: game) }
  let!(:comment2){ Fabricate(:comment, body: 'A comment from parent 2', parent: parent2, game: game) }

  let!(:pod2){ Fabricate(:pod) }
  let!(:parent_from_pod2){ Fabricate(:parent, name: 'Tim Cook', phone: '07515433333', pod: pod2) }

  before do
    visit "/#/#{parent.slug}/games/"
    find(:css, '.gameItem').click
  end

  describe "accessing the comments page for a game" do
    it "should display the comments page for the game" do
      click_link 'Load comments'
      expect(page).to have_content('Here is my comment')
      expect(page).to have_content('A comment from parent 2')
      expect(page).to have_content('Bob S.')
    end
  end

  describe "adding a comment" do
    it "should show the comment after you add it" do
      click_link   'Load comments'
      fill_in      'comment', with: 'This was a great game.'
      click_button 'Add comment'

      expect(page).to have_content('This was a great game.')
    end
  end

  describe "viewing commments" do
    it "should show you comments only from other members of your pod" do
      visit "/#/#{parent.slug}/game/#{game.id}/comments/"
      expect(page).to have_content('Here is my comment')

      visit "/"

      visit "/#/#{parent_from_pod2.slug}/game/#{game.id}/comments/"
      expect(page).not_to have_content('Here is my comment')
    end
  end

end
