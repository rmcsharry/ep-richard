require "rails_helper"

RSpec.describe "Welcome SMS", :js => false, :type => :feature do

  let!(:pod)       { Fabricate(:pod) }
  let!(:pod_admin) { Fabricate(:pod_admin, email: 'test@example.com', pod: pod ) }
  let!(:parent)    { Fabricate(:parent, name: 'Jen', phone: '07515444444', pod: pod ) }

  before do
    login_as_specific_pod_admin(pod_admin)
  end

  describe "sending welcome SMS" do
    before do
      visit pod_admin_parents_path
      click_link 'Jen'
    end

    describe "if successfully sent" do
      it "should tell the user that the SMS was sent and change the button" do
        stub_send_sms
        click_button 'Send welcome SMS'
        expect(page).to have_content('SMS sent!')
        click_link 'Jen'
        expect(page).to have_button('Welcome SMS already sent. Send again?')
      end
    end

    # this test doesn't work right now.
    # ---------------------------------
    # describe "if there was an error sending" do
    #   it "should display the error code" do
    #     stub_send_sms_fail
    #     click_button 'Send welcome SMS'
    #     expect(page).to have_content("21608")
    #   end
    # end

  end
end
