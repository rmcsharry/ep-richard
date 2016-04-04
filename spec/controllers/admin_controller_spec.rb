require 'rails_helper'

RSpec.describe AdminController do
  before do
    file_path = Rails.root.join('spec/fixtures/files/2_parents_test.csv')
    @file = Rack::Test::UploadedFile.new(file_path, 'text/csv')
  end

  it "can upload a csv file of parents" do
    post :parents_import, :pod_id => 1, :file => @file
    response.should be_success
  end
  
end

# test "image upload" do
  # test_image = path-to-fixtures-image + "/Test.jpg"
  # file = Rack::Test::UploadedFile.new(test_image, "image/jpeg")
  # post "/create", :user => { :avatar => file }
  # ... assert desired results ...
# end