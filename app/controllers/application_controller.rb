class ApplicationController < ActionController::Base
  include GtfsEngine::Concerns::Controllers::DataAccess
  include GtfsEngine::DefaultViewsHelper

  respond_to :json
end
