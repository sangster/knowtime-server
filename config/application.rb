require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require :default, Rails.env
require File.expand_path('../knowtime', __FILE__)

module BustedRuby
  class Application < Rails::Application
    to_remove = %W(ActionDispatch::RequestId)
    to_remove.each { |w| config.middleware.delete w }
    config.action_dispatch.default_headers = {}

    config.generators.instance_exec do
      template_engine     :jbuilder
      test_framework      :rspec, fixture: false
      stylesheets         false
      javascripts         false
      fixture_replacement :factory_girl, dir: 'spec/factories'
    end
    
    config.time_zone = 'America/Halifax'
    config.assets.enabled = true
  end
end
