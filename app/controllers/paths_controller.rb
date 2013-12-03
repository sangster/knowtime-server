class PathsController < ApplicationController
  respond_to :json

  def show
    @path = Path.for_uuid params[:path_uuid]
    render_error :not_found, "no path found for UUID: #{params[:path_uuid]}" if @path.nil?

    respond_with @path
  end


  def index_for_route_and_date
    calendars = Calendar.for_date_params params
    route = Route.for_uuid params[:route_uuid]
    render_error :not_found, 'no paths found' if calendars.empty? or route.nil?

    @paths = Path.for_route_and_calendars route, calendars
  end
end
