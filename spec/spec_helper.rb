require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  # nothing!
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
