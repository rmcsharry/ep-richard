require 'rails_helper'

RSpec.describe Parent, :type => :model do

  let(:parent) { Parent.new }

  describe "phone number" do

    before do
      parent.name = "Basil Safwat"
    end

    describe "less than 11 digits" do
      it "should be invalid" do
        parent.phone = "0"
        expect(parent.valid?).to eq(false)
      end
    end

    describe "exactly 11 digits" do
      describe "not starting 07" do
        it "should be invalid" do
          parent.phone = "06555555555"
          expect(parent.valid?).to eq(false)
        end
      end
      describe "starting 07" do
        it "should be valid" do
          parent.phone = "07555555555"
          expect(parent.valid?).to eq(true)
        end
      end
    end

  end
end
