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

    context "with an email address that exists in the db and is confirmed" do
      let(:admin) { Fabricate(:admin, confirmed_at: Date.today) }
        
      it "sends account already exists email and returns 304 Not Modified" do
        post :create, email: admin.email, format: :json
        allow(PodAdminMailer).to receive(:account_already_exists_email).and_return(true)
        allow(PodAdminMailer.account_already_exists_email).to receive(:deliver).and_return(true)
        
        expect(admin.send_account_already_exists_email).to eq(true)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.status).to eq(304)
      end
    end
    
    context "with an email address that exists in the db and is not confirmed" do
      let(:admin) { Fabricate(:admin, confirmed_at: nil) }

      it "resends confirmation instructions email and returns 304 Not Modified" do      
        post :create, email: admin.email, format: :json
   
        expect(admin.resend_confirmation_instructions).to have_content("Welcome to EasyPeasy! Confirm your details")
        expect{ admin.resend_confirmation_instructions }.to change(Devise.mailer.deliveries, :count).by(1)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.status).to eq(304)
      end
    end

  end
end