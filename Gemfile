source 'https://rubygems.org'

gem 'gem_bench', :group => :console # use this to analyse in the console which gems are not required at boot: https://github.com/pboling/gem_bench

gem 'rails', '4.1.1'
gem 'pg', require: false

gem 'sass-rails', '~> 4.0.3', require: false
gem 'uglifier', '>= 1.3.0', require: false
gem 'redcarpet', require: false

gem 'jquery-rails'

gem 'ember-rails'
gem 'handlebars', require: false
gem 'active_model_serializers'
gem 'coffee-rails'
gem 'foreman', require: false
gem 'unicorn', require: false
gem 'pry', require: false
gem 'devise', '~> 3.5.4'
gem 'autoprefixer-rails'
gem "exception_notification", git: "git://github.com/rails/exception_notification", require: 'exception_notifier'
gem 'twilio-ruby', '~> 3.12', require: false
gem 'whenever', require: false
gem 'acts_as_list'
gem 'rails_real_favicon', require: false # cross-device favicon
gem 'wicked' # wizard builder

group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'capybara'
  gem 'poltergeist', '~> 1.9.0'
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'launchy'
end

group :development do
  gem 'recap', require: false
end

group :test do
  gem 'webmock'
end

group :staging do
  ruby '2.1.2'
end