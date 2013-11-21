class PathsController < ApplicationController
  def show
    @path = Uuid.find_idable params[:path_uuid]
    raise ActiveRecord::RecordNotFound if @path.nil?
  end


  def show_for_route_and_date
    calendars = Calendar.for_date_params params
    route = Uuid.find_idable params[:route_uuid]
    raise ActiveRecord::RecordNotFound if calendars.empty? or route.nil?

    @paths = Path.for_route_and_calendars route, calendars
  end
end
