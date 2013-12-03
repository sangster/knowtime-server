class PathsController < ApplicationController
  respond_to :json

  def show
    @path = Path.for_uuid params[:path_uuid]

    if @path
      respond_with @path
    else
      render_error :not_found, "no path found for UUID: #{params[:path_uuid]}" .nil?
    end
  end


  def index_for_route_and_date
    calendars = Calendar.for_date_params params
    unless calendars and calendars.any?
      render_error :not_found, 'no calendars found for given date'
      return
    end

    route = Route.for_uuid params[:route_uuid]
    unless route
      render_error :not_found, 'no route found for given uuid'
      return
    end
    
    @paths = Path.for_route_and_calendars route, calendars
    respond_with @paths
  end
end
