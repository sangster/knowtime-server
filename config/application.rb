require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'mongoid/railtie'

require File.expand_path('../knowtime', __FILE__)

Bundler.require(:default, Rails.env)

module BustedRuby
  class Application < Rails::Application

    config.autoload_paths += Dir["#{config.root}/app/models/v*/"]

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

    config.assets.enabled = true
  end
end
