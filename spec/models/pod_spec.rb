require 'rails_helper'

RSpec.describe Pod, :type => :model do

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
    end  # two parent context  
    
    private
    def log_a_visit(parent)
      log = ParentVisitLog.new(created_at: Date.today.prev_day)
      log.parent_id = parent.id
      log.pod_id = pod.id
      log.save
    end
  end
end
