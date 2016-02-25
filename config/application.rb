require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'twilio-ruby'

ActiveSupport::Logger.class_eval do 
  # monkey patching here so there aren't duplicate lines in console/server
  # fixed in Rails 4.2, see https://github.com/rails/rails/pull/22592
  def self.broadcast(logger) 
    Module.new do
    end
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Easypeasy
  class Application < Rails::Application

    config.to_prepare do
      Devise::SessionsController.layout "admin"
      Devise::PasswordsController.layout "admin"
    end

    config.logger.define_singleton_method(:extend) {|*args| }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
