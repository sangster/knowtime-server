class RoutesController < ApplicationController
  def show
    @route = Uuid.find_idable params[:route_uuid]
    raise ActiveRecord::RecordNotFound if @route.nil?
  end


  def show_with_trips_on_date
    @route = Uuid.find_idable params[:route_uuid]
    raise ActiveRecord::RecordNotFound if @route.nil?

    @calendars = Calendar.for_date_params params
  end


  def index
    @routes = Route.all
  end


  def names
    @names = Route.names
  end

  def index_for_short_name_and_date
    @routes = Route.for_short_name_and_calendars params[:short_name], Calendar.for_date_params(params)
  end
end
