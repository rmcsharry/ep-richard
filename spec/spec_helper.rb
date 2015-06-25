require 'capybara/poltergeist'
require 'webmock/rspec'

# Tell webmock to allow connections to localhost
WebMock.disable_net_connect!(:allow_localhost => true)

def stub_get_video_from_wistia
  stub_request(:get, "http://fast.wistia.com/oembed?url=https://minified.wistia.com/medias/q8x0tmoya2?videoFoam=true").
    to_return(:status => 200, :body => File.new('spec/webmocks/getVideoFromWistia.json'), :headers => {})
end

def stub_send_sms
  stub_request(:post, /.+api\.twilio\.com.+/).
    to_return(:status => 201, :body => File.new('spec/webmocks/sendSMS.json'), :headers => {})
end

def stub_send_sms_fail
  stub_request(:post, /.+api\.twilio\.com.+/).
    to_return(:status => 400, :body => File.new('spec/webmocks/sendSMSfail.json'), :headers => {})
end

# Suppress warnings we know about - comma separated and surrounded by /MESSAGE/
class WarningSuppressor
  IGNORES = [
    /DEBUG:/,
  ]
 
  class << self
    def write(message)
      if suppress?(message) then 0 else puts(message);1;end
    end

    private

    def suppress?(message)
      IGNORES.any? { |re| message =~ re }
    end
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :window_size => [640, 1136], :phantomjs_logger => WarningSuppressor)
end

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
end

def json(body)
  JSON.parse(body, symbolize_names: true)
end

def screenshot
  page.driver.render('./tmp/screenshot.png')
  `open ./tmp/screenshot.png`
end

def login_as_admin
  Fabricate(:easy_admin)
  visit admin_login_path
  fill_in "Email", with: "bsafwat@gmail.com"
  fill_in "Password", with: "Password1"
  click_button "Sign in"
end

def login_as_pod_admin
  Fabricate(:pod_admin, email: "bsafwat+podadmin@gmail.com", password: "Password2")
  visit admin_login_path
  fill_in "Email", with: "bsafwat+podadmin@gmail.com"
  fill_in "Password", with: "Password2"
  click_button "Sign in"
end

def login_as_specific_pod_admin(pod_admin)
  visit admin_login_path
  fill_in "Email", with: pod_admin.email
  fill_in "Password", with: pod_admin.password
  click_button "Sign in"
end

def logout_admin
  click_link 'Logout'
end
