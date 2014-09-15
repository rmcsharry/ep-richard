require "rails_helper"

RSpec.describe "Go live", :js => false, :type => :feature do

  describe "the go live date for a pod" do

    it "should initially be not set"
    it "should show a button if not set"
    it "clicking the button should set the go live date to today"
    it "should not show the button if the go live date is set"
    it "should show the go live date if there is one"

  end

end
