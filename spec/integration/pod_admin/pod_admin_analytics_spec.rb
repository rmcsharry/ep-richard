require "rails_helper"

RSpec.describe "Analytics email", :js => true, :type => :feature do

  let!(:pod)        { Fabricate(:pod, name: 'Brockley Pod') }
  let!(:pod_admin)  { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
  let!(:parent1)    { Fabricate(:parent, name: 'Jen', phone: '07515444444', pod: pod ) }
  let!(:parent2)    { Fabricate(:parent, name: 'Basil', phone: '07515444445', pod: pod ) }
  let!(:parent3)    { Fabricate(:parent, name: 'Gabi', phone: '07515444446', pod: pod ) }
  # not in pod
  let!(:pod2)       { Fabricate(:pod, name: 'Other pod') }
  let!(:parent4)    { Fabricate(:parent, name: 'James', phone: '07515444447', pod: pod2 ) }
  # game
  let!(:game1) { Fabricate(:game, name: "Game 1", description: "Game 1 desc", in_default_set: true) }
  let!(:game2) { Fabricate(:game, name: "Game 2", description: "Game 2 desc", in_default_set: true) }

  before do
    login_as_specific_pod_admin(pod_admin)
  end

  describe "the test page" do

    before { visit pod_admin_analytics_path }

    it "should be accessible" do
      expect(page).to have_content("Brockley Pod's Weekly Report")
    end

    it "should show the correct date range (the last week)" do
      start_date = Date.yesterday - 7.days
      end_date   = Date.yesterday
      expect(page).to have_content(start_date.strftime("%A, %b %d"))
      expect(page).to have_content(end_date.strftime("%A, %b %d"))
    end

    it "should show the correct number of parents in the pod" do
      expect(page).to have_content("Of the 3 parents in your pod")
    end

    describe "visit numbers" do

      it "should say how many parents visited the pod" do
        visit "/#/#{parent1.slug}/games"
        visit pod_admin_analytics_path
        expect(page).to have_content("1 of them visited EasyPeasy last week")
      end

      it "should not count a visit from someone from another pod" do
        visit "/#/#{parent4.slug}/games"
        visit pod_admin_analytics_path
        expect(page).to have_content("0 of them visited EasyPeasy last week")
      end

      it "a parent visiting twice should only be counted once" do
        visit "/#/#{parent1.slug}/games"
        visit pod_admin_analytics_path
        visit "/#/#{parent1.slug}/games"
        visit pod_admin_analytics_path
        expect(ParentVisitLog.count).to eq(2)
        expect(page).to have_content("1 of them visited EasyPeasy last week")
      end

      it "a parent visiting a game page directly should be counted as a visit" do
        visit "/#/#{parent1.slug}/game/#{game1.id}"
        sleep(0.1)
        expect(ParentVisitLog.count).to eq(1)
      end

      it "should say what the most visited game is" do
        visit "/#/#{parent1.slug}/game/#{game1.id}"
        visit pod_admin_analytics_path
        visit "/#/#{parent1.slug}/game/#{game2.id}"
        visit pod_admin_analytics_path
        visit "/#/#{parent1.slug}/game/#{game1.id}"
        visit pod_admin_analytics_path
        expect(page).to have_content("The most visited game was Game 1")
      end

      it "should say what the most visited game last week was"
      it "should say what the most visited game of all time is"
      it "should say how many people visited last week"
      it "should say how many comments have been posted in total"
      it "should say which post has the most comments"
      it "should say who in the pod has posted the most comments"
      it "should show the latest 5 comments and no more"
      it "should show a link to view all comments"
      it "should say who hasn't yet commented"
      it "should omit the sentence when everyone has commented"
      it "should correctly pluralize 'people have commented"
      it "should say what the next game to be released will be"
      it "should handle the case where there are no more games to be released"
    end
  end

end
