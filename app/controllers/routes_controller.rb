class RoutesController < ApplicationController
  def index
    @routes = Route.all
  end
end
