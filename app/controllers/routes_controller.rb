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


  def index_by_query
    @routes = query_routes params[:key], params[:value]
  end


  private


  def query_routes key, val
    case key
      when 'short'
        Route.where short_name: val
      when 'long'
        Route.where long_name: val
      when 'stop'
        stop = Stop.get val.to_i
        Route.uniq.joins(:trips, :stop_times).where 'stop_times.stop_id' => stop
      when 'date'
        calendars = Calendar.for_date Date.parse(val)
        Route.uniq.joins(:trips).where 'trips.calendar_id' => calendars
      else
        raise ActiveRecord::RecordNotFound
    end
  end
end
