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
        expect(body["errors"]).to include("Email can't be blank")
        expect(response.status).to eq(422)
      end
    end
    
    context "with blank email address" do
      it "responds with JSON, 422 Unprocessible Entity and error in the body" do
        post :create, email: '', format: :json
        
        expect(response.content_type).to eq(Mime::JSON)
        expect { JSON.parse(response.body) }.to_not raise_error
        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Email can't be blank")
        expect(response.status).to eq(422)
      end
    end

    context "with an email address that exists in the db and is confirmed" do
      let!(:admin) { Fabricate(:admin, confirmed_at: Date.today) }
        
      it "sends account already exists email and returns 304 Not Modified" do
        expect(admin.confirmed?).to eq(true)
        pod_admin_mailer_count = PodAdminMailer.deliveries.count
        
        post :create, email: admin.email, format: :json

        expect(PodAdminMailer.deliveries.count).to eq(pod_admin_mailer_count + 1)
        sent_email = ActionMailer::Base.deliveries.last
        expect(sent_email["Subject"]).to have_content("Login to EasyPeasy!")
        expect(sent_email["to"]).to have_content(admin.email)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.status).to eq(304)
      end
    end
    
    context "with an email address that exists in the db and is not confirmed" do
      let!(:admin) { Fabricate(:admin) }

      it "resends confirmation instructions email and returns 304 Not Modified" do      
        expect(admin.confirmed?).to eq(false)
        devise_mail_count = ActionMailer::Base.deliveries.count
        
        post :create, email: admin.email, format: :json
        
        expect(ActionMailer::Base.deliveries.count).to eq(devise_mail_count + 1)
        sent_email = ActionMailer::Base.deliveries.last
        expect(sent_email["Subject"]).to have_content("Welcome to EasyPeasy! Confirm your details")
        expect(sent_email["to"]).to have_content(admin.email)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.status).to eq(304)
      end
    end

  end
end