require 'rails_helper'

RSpec.describe Pod, :type => :model do
  let!(:game1) { Fabricate(:game, position: 1, in_default_set: false) }

  describe "when it is not live" do
    let(:pod) { Fabricate(:pod) }
    
    it "should not have a week number" do
      expect(pod.week_number).to eq nil
    end
    
    it "should not have a current game" do
      expect(pod.current_game).to eq nil
    end
  end
  
  describe "logs visits" do
    let(:pod) { Fabricate(:pod) }
    let(:parentA) { Fabricate(:parent, pod: pod) }

    context "with 0 parents" do
      it "returns 0 visitors and 0 non-visitors" do
        expect(pod.parents_who_visited("last_week").count).to eq 0
        expect(pod.parents_who_visited("all_time").count).to eq 0
        expect(pod.parents_who_did_not_visit("last_week").count).to eq 0
        expect(pod.parents_who_did_not_visit("all_time").count).to eq 0
      end      
    end
    
    context "with 1 parent" do
      it "returns parentA with 1 visit" do
        log_a_visit(parentA)       
        expect(pod.parents_who_visited("last_week")).to eq({ parentA.id => 1 })
        expect(pod.parents_who_visited("all_time")).to eq({ parentA.id => 1 })
      end
      
      it "returns parentA with 2 visits" do
        log_a_visit(parentA)
        log_a_visit(parentA)
        expect(pod.parents_who_visited("last_week")).to eq({ parentA.id => 2 })
        expect(pod.parents_who_visited("all_time")).to eq({ parentA.id => 2 })
      end     
    end  # one parent context  


    context "with two parents" do
      let(:parentB) { Fabricate(:parent, pod: pod) }
      
      it "returns parentA with 1 visit and parentB did not visit" do
        log_a_visit(parentA)
        expect(pod.parents_who_visited("last_week")).to eq({ parentA.id => 1 })
        expect(pod.parents_who_visited("all_time")).to eq({ parentA.id => 1 })
        expect(parentB.pod.id).to eq pod.id # need this expectation to force the relationship between parentB and pod, else the next 2 tests fail
        expect(pod.parents_who_did_not_visit("last_week")).to eq [parentB.id]
        expect(pod.parents_who_did_not_visit("all_time")).to eq [parentB.id]              
      end
            
      it "returns 2 parents with 1 visit each and non-visitors is empty" do
        log_a_visit(parentA)
        log_a_visit(parentB)
        expect(pod.parents_who_visited("last_week")).to eq({ parentA.id => 1, parentB.id => 1 })
        expect(pod.parents_who_visited("all_time")).to eq({ parentA.id => 1, parentB.id => 1 })
        expect(pod.parents_who_did_not_visit("last_week")).to eq []
        expect(pod.parents_who_did_not_visit("all_time")).to eq []         
      end
      
      it "returns 2 parenst in descending order of visits and non-visitors is empty" do
        log_a_visit(parentA)
        log_a_visit(parentB)
        log_a_visit(parentB)
        expect(pod.parents_who_visited("last_week")).to eq({ parentB.id => 2, parentA.id => 1 })
        expect(pod.parents_who_visited("all_time")).to eq({ parentB.id => 2, parentA.id => 1 })
        expect(pod.parents_who_did_not_visit("last_week")).to eq []
        expect(pod.parents_who_did_not_visit("all_time")).to eq []            
      end 

      it "returns nil for parents played" do
        log_a_visit(parentA)
        log_a_visit(parentB)
        log_a_visit(parentB)
        expect(pod.parents_played).to eq(nil)
      end
    end  # two parent context  

    context "with three parents" do
      let(:parentB) { Fabricate(:parent, pod: pod) }
      let(:parentC) { Fabricate(:parent, pod: pod) }
      
      it "returns correct text for parents played" do
        pod.go_live_date = Date.today - 7.days
        parentB.name = 'Mickey Mouse'
        parentB.save
        log_a_visit(parentA)
        log_a_visit(parentB)
        log_a_visit(parentC)
        expect(pod.parents_played).to eq("Basil, Mickey and 1 other parent have played this weeks game.")
      end
    end

    context "with four parents" do
      let(:parentB) { Fabricate(:parent, pod: pod) }
      let(:parentC) { Fabricate(:parent, pod: pod) }
      let(:parentD) { Fabricate(:parent, pod: pod) }
      
      it "returns correct text for parents played" do
        pod.go_live_date = Date.today - 7.days
        parentB.name = 'Mickey Mouse'
        parentB.save
        log_a_visit(parentA)
        log_a_visit(parentB)
        log_a_visit(parentC)
        log_a_visit(parentD)
        expect(pod.parents_played).to eq("Basil, Mickey and 2 other parents have played this weeks game.")
      end
    end    

    describe "returns latest comment" do
      it "from a parent" do
        game = Game.create!(name: "Test game", video_url: "https://minified.wistia.com/medias/q8x0tmoya2")
  
        pod1 = Pod.create!(name: "Pod 1")
        
        parent1 = Parent.create!(name: "Richard", phone: "07963250340", pod: pod1)
        parent2 = Parent.create!(name: "Gerard", phone: "07963250340", pod: pod1)
  
        latest_comment = "This is the latest comment"
        comment1 = Comment.create!(body: "Hello", game: game, parent: parent1)
        comment2 = Comment.create!(body: latest_comment,   game: game, parent: parent2)
        
        expect(pod1.latest_comment.body).to include(latest_comment)
      end
    end
    
    private
    def log_a_visit(parent)
      log = ParentVisitLog.new(created_at: Date.today.prev_day)
      log.parent_id = parent.id
      log.pod_id = pod.id
      log.game_id = game1.id
      log.save
    end
  end
end
