class PathsController < ApplicationController
  def show
    @path = Path.for_uuid params[:path_uuid]
    raise ActiveRecord::RecordNotFound if @path.nil?
  end


  def index_for_route_and_date
    calendars = Calendar.for_date_params params
    route = Route.for_uuid params[:route_uuid]
    raise ActiveRecord::RecordNotFound if calendars.empty? or route.nil?

    @paths = Path.for_route_and_calendars route, calendars
  end
end
