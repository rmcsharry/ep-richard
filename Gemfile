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
gem 'devise'
gem 'autoprefixer-rails'
gem "exception_notification", :git => "git://github.com/rails/exception_notification", :require => 'exception_notifier'
gem 'twilio-ruby', '~> 3.12', require: false
gem 'whenever', :require => false
gem 'acts_as_list'

group :development, :test do
  gem 'spring', require: false
  gem 'spring-commands-rspec', require: false
  gem 'rspec-rails', '~> 3.0.0', require: false
  gem 'capybara', require: false
  gem 'poltergeist', '~> 1.6.0', require: false
  gem 'database_cleaner', require: false
  gem 'fabrication', require: false
end

group :development do
  gem 'recap', require: false
end

group :test do
  gem 'webmock'
end
