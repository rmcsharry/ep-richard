require 'capybara/poltergeist'

class WarningSuppressor
  IGNORES = [
    /DEBUG:/,
    /Viewport argument key "minimal-ui" not recognized and ignored./
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
  Fabricate(:admin)
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
