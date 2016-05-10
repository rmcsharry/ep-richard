require "rails_helper"

RSpec.describe "Comments", :js => true, :type => :feature do
  let!(:pod){ Fabricate(:pod) }
  
  let!(:parent1){ Fabricate(:parent, name: 'Basil Safwat', phone: '07515333333', pod: pod) }
  let!(:parent2){ Fabricate(:parent, name: 'Bob Smith', pod: pod) }
  
  let!(:game){ Fabricate(:game, in_default_set: true) }
  let!(:comment1){ Fabricate(:comment, body: 'A comment from parent 1', parent: parent1, game: game) }
  let!(:comment2){ Fabricate(:comment, body: 'A comment from parent 2', parent: parent2, game: game) }

  let!(:pod2){ Fabricate(:pod) }
  let!(:parent_from_pod2){ Fabricate(:parent, name: 'Tim Cook', phone: '07515433333', pod: pod2) }

  before do
    # must trigger a visit by both parents to avoid intro screens showing
    Fabricate(:parent_visit_log, parent: parent1)
    Fabricate(:parent_visit_log, parent: parent2)
    visit "/#/#{parent1.slug}/games/"
    sleep 0.02
    find(:css, '.gameItem').click
  end

  describe "accessing the comments page for a game" do
    it "should display the comments page for the game" do
      expect(page).to have_content('A comment from parent 1')
      expect(page).to have_content('A comment from parent 2')
      expect(page).to have_content('Bob S.')\
    end
    
    it "should dispaly the comments in the reverse order they were created" do
      expect(page).to have_text(/A comment from parent 2 .+ A comment from parent 1/)
      expect(page).not_to have_text(/A comment from parent 1 .+ A comment from parent 2/)
    end
  end

  describe "adding a comment" do
    it "should show the comment after you add it" do
      fill_in      'comment', with: 'This was a great game.'
      click_button 'Share comment'
      
      expect(page).to have_content('This was a great game.')
    end

    it "should not allow you to add a blank comment" do
      fill_in      'comment', with: ' '
      click_button 'Share comment'

      expect(page).to have_selector('.commentItem', count: 2)
    end
  end

  describe "viewing commments" do
    it "should show you comments only from other members of your pod" do
      visit "/#/#{parent1.slug}/game/#{game.id}/"
      expect(page).to have_content('A comment from parent 1')

      visit "/"

      visit "/#/#{parent_from_pod2.slug}/game/#{game.id}/"
      expect(page).not_to have_content('A comment from parent 1')
    end
  end

end
