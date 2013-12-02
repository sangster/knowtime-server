require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'mongoid/railtie'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module BustedRuby
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    to_remove = %W(ActionDispatch::RequestId )
    to_remove.each { |w| config.middleware.delete w }
    config.action_dispatch.default_headers = {}

    config.generators do |g|
        g.orm             :mongoid
        g.template_engine :jbuilder
        g.test_framework  :rspec, fixture: false
        g.stylesheets     false
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
    
    config.time_zone = 'America/Halifax'
  end
end
