class RoutesController < ApplicationController
  def show
    @route = Uuid.find_idable params[:route_uuid]
    raise ActiveRecord::RecordNotFound if @route.nil?
  end


  def index
    @routes = Route.all
  end


  def names
    @names = Route.names
  end
end
