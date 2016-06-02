require 'rails_helper'

RSpec.describe Admin::ConfirmationsController, :type => :controller do

  describe "POST create" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
    end

    context "with an email address that does not exist in the db" do
      before :each do
        post :create, email: 'test@test.com', format: :json
      end
      
      it "creates an unconfirmed admin account" do
        expect(Admin.last.confirmed?).to eq(false)
      end
      
      it "creates the admin without an admin type" do
        expect(Admin.last.type).to be_nil
      end
      
      it "creates the admin without assigning a pod" do
        expect(Admin.last.pod_id).to be_nil      
      end
      
      it "responds with JSON and 201 Created" do
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.status).to eq(201)
      end
    end

    context "with no email address" do
      it "responds with JSON, 422 Unprocessible Entity and error in the body" do
        post :create, format: :json
        
        expect(response.content_type).to eq(Mime::JSON)
        expect { JSON.parse(response.body) }.to_not raise_error        
        body = JSON.parse(response.body)
        expect(body["email"]).to include("can't be blank")
        expect(response.status).to eq(422)
      end
    end
    
    context "with blank email address" do
      it "responds with JSON, 422 Unprocessible Entity and error in the body" do
        post :create, email: '', format: :json
        
        expect(response.content_type).to eq(Mime::JSON)
        expect { JSON.parse(response.body) }.to_not raise_error
        body = JSON.parse(response.body)
        expect(body["email"]).to include("can't be blank")
        expect(response.status).to eq(422)
      end
    end

    context "with an email address that already exists in the db" do
      
      it "resends confirmation instructions email if account is unconfirmed" do
      end
      
      it "sends account already exists email if account is confirmed" do
        pod_admin = PodAdmin.create(email: 'test@test.com', confirmed_at: Date.today)
        post :create, email: 'test@test.com', format: :json
        allow(PodAdminMailer).to receive(:account_already_exists_email).and_return(true)
        allow(PodAdminMailer.account_already_exists_email).to receive(:deliver).and_return(true)
        
        expect(pod_admin.send_account_already_exists_email).to eq(true)
      end
      
      it "responds with JSON and 304 Not Modified" do
        pod_admin = Admin.create(email: 'test@test.com')
        post :create, email: 'test@test.com', format: :json
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.status).to eq(304)      
      end
    end
  end
end