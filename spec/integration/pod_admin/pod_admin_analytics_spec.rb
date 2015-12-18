require "rails_helper"

RSpec.describe "Analytics email", :js => true, :type => :feature do

  let!(:pod)        { Fabricate(:pod, name: 'Brockley Pod', go_live_date: Date.today.midnight - 7.days) }
  let!(:pod_admin)  { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
  let!(:parent1)    { Fabricate(:parent, name: 'Jen Lexmond', phone: '07515444444', pod: pod ) }
  let!(:parent2)    { Fabricate(:parent, name: 'Basil Safwat', phone: '07515444445', pod: pod ) }
  let!(:parent3)    { Fabricate(:parent, name: 'Gabi Miller', phone: '07515444446', pod: pod ) }
  # not in pod
  let!(:pod2)       { Fabricate(:pod, name: 'Other pod') }
  let!(:parent4)    { Fabricate(:parent, name: 'James Smith', phone: '07515444447', pod: pod2 ) }
  # game
  let!(:game1) { Fabricate(:game, name: "Game 1", description: "Game 1 desc", in_default_set: true) }
  let!(:game2) { Fabricate(:game, name: "Game 2", description: "Game 2 desc", in_default_set: false) }
  let!(:game3) { Fabricate(:game, name: "Game 3", description: "Game 3 desc", in_default_set: false) }

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
        expect(ParentVisitLog.all.count).to eq(0)
        visit "/#/#{parent1.slug}/games"
        sleep 0.1
        expect(ParentVisitLog.all.count).to eq(1)
      end

      it "should log the pod id correctly" do
        visit "/#/#{parent4.slug}/games"
        sleep 0.1
        expect(ParentVisitLog.first.pod_id).to eq(parent4.pod_id)
      end

      it "a parent visiting a game page directly should be counted as a visit" do
        visit "/#/#{parent1.slug}/game/#{game1.id}"
        sleep(0.1)
        expect(ParentVisitLog.count).to eq(1)
      end

      describe "most visited game stat" do
        before do
          last_week = Date.today.midnight - 7.days
          this_week = Date.today + 1.hour
          # Two of game 1 last week
          ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, created_at: last_week)
          ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, created_at: last_week)
          ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game2.id, created_at: last_week)
          # Three of game 2 this week
          ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game2.id, created_at: this_week)
          ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game2.id, created_at: this_week)
          ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game2.id, created_at: this_week)
          visit pod_admin_analytics_path
        end
        it "should say what the most visited game last week was" do
          expect(page).to have_content("The most visited game was Game 1")
        end
        it "should say what the most visited game of all time is" do
          expect(page).to have_content("most popular game so far is Game 2")
        end
      end

      it "should say how many people visited last week" do
        last_week = Date.today.midnight - 7.days
        this_week = Date.today.midnight + 1.hour
        # Three visits by parent 1 and one by parent 2 last week
        ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, created_at: last_week)
        ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, created_at: last_week)
        ParentVisitLog.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, created_at: last_week)
        ParentVisitLog.create!(parent_id: parent2.id, pod_id: parent1.pod.id, game_id: game1.id, created_at: last_week)
        # Two by parent 3 this week
        ParentVisitLog.create!(parent_id: parent3.id, pod_id: parent1.pod.id, game_id: game2.id, created_at: this_week)
        ParentVisitLog.create!(parent_id: parent3.id, pod_id: parent1.pod.id, game_id: game2.id, created_at: this_week)
        visit pod_admin_analytics_path
        expect(page).to have_content("2 of them visited EasyPeasy last week")
      end
    end # game visits

    describe "comment stats" do
      before do
        last_week = Date.today.midnight - 7.days
        Comment.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, body: "Comment 1", created_at: last_week)
        Comment.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, body: "Comment 2", created_at: last_week)
        Comment.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, body: "Comment 3", created_at: last_week)
        Comment.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, body: "Comment 4", created_at: last_week)
        Comment.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, body: "Comment 5", created_at: last_week)
        Comment.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game1.id, body: "Comment 6", created_at: last_week)
        Comment.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game2.id, body: "Comment 7", created_at: last_week)
        # not in pod
        Comment.create!(parent_id: parent4.id, pod_id: parent4.pod.id, game_id: game2.id, body: "Comment 8", created_at: last_week)
        # created now
        Comment.create!(parent_id: parent1.id, pod_id: parent1.pod.id, game_id: game2.id, body: "Comment 9", created_at: Date.today.midnight + 1.hour)
        visit pod_admin_analytics_path
      end

      it "should say how many comments were posted last week" do
        expect(page).to have_content("Your pod posted 7 messages")
      end

      it "should say which post has the most comments this week" do
        expect(page).to have_content("Game 1 had the most posts with 6 messages")
      end

      it "should say who in the pod has posted the most comments" do
        expect(page).to have_content("The most chatty member of your pod was Jen Lexmond")
      end

      it "should show the latest 5 comments and no more" do
        expect(page).to have_content("Comment 1")
        expect(page).to have_content("Comment 2")
        expect(page).to have_content("Comment 3")
        expect(page).to have_content("Comment 4")
        expect(page).to have_content("Comment 5")
        expect(page).not_to have_content("Comment 6")
        expect(page).not_to have_content("Comment 7")
        expect(page).not_to have_content("Comment 8")
        expect(page).not_to have_content("Comment 9")
      end

      it "should show a link to view all comments" do
        expect(page).to have_content("View all chats...")
      end

      it "should show all comments when the link is clicked" do
        click_link "View all chats..."
        expect(page).to have_content("Comment 1")
        expect(page).to have_content("Comment 2")
        expect(page).to have_content("Comment 3")
        expect(page).to have_content("Comment 4")
        expect(page).to have_content("Comment 5")
        expect(page).to have_content("Comment 6")
        expect(page).to have_content("Comment 7")
        expect(page).not_to have_content("Comment 8")
        expect(page).to have_content("Comment 9")
      end

      it "should say who hasn't yet commented" do
        expect(page).to have_content("2 people might be a bit shy and haven't commented yet: Basil Safwat, Gabi Miller.")
      end

      it "should say who hasn't yet commented if only one person hasn't commented" do
        Parent.where(id: parent3.id)[0].destroy
        visit pod_admin_analytics_path
        expect(page).to have_content("1 person might be a bit shy and hasn't commented yet: Basil Safwat.")
      end

      it "should omit the sentence when everyone has commented" do
        expect(page).to have_content("a bit shy")
        Comment.create!(parent_id: parent2.id, body: "Hello")
        Comment.create!(parent_id: parent3.id, body: "Hello")
        visit pod_admin_analytics_path
        expect(page).not_to have_content("a bit shy")
      end

      it "should say what the next game to be released will be" do
        expect(page).to have_content("next game released will be Game 2")
      end

      it "should handle the case where there are no more games to be released" do
        pod.go_live_date = Date.today.midnight - 3*7.days
        pod.save
        visit pod_admin_analytics_path
        expect(page).not_to have_content("next game released will be")
      end

      it "should be able to handle a situation where no one has commented yet"
    end

    describe "no comments" do
      it "should not say which the most commented game was" do
        expect(page).to have_content("Your pod posted 0 messages")
        expect(page).not_to have_content("had the most posts with")
      end
      it "should not say who in the pod has posted the most comments" do
        expect(page).not_to have_content("The most chatty member of your pod was Jen Lexmond")
      end
    end

  end
end
