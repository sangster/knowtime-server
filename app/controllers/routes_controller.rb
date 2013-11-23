class RoutesController < ApplicationController
  def show
    @route = Route.for_uuid params[:route_uuid]
    raise ActiveRecord::RecordNotFound if @route.nil?
  end


  def show_with_trips_on_date
    @route = Route.for_uuid params[:route_uuid]
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
    @routes = Route.simple_query params[:key], params[:value]
  end


  def index_by_query_with_headsigns
    query_with_headsigns Calendar.for_date_params(params), params[:key], params[:value]
  end


  def index_by_date_with_headsigns
    date_str = "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    query_with_headsigns Calendar.for_date_params(params), 'date', date_str
  end


  def index_by_query_and_time_with_headsigns
    index_by_query_with_headsigns
    @minutes = params[:hours].to_i * 60 + params[:minutes].to_i
  end


  def index_by_date_and_time_with_headsigns
    index_by_date_with_headsigns
    @minutes = params[:hours].to_i * 60 + params[:minutes].to_i
  end

  private


  def query_with_headsigns calendars, key, value
    @routes = Route.simple_query key, value

    @route_trips = {}
    @routes.each do |r|
      trips = r.trips.where(calendar_id: calendars).sort! do |x, y|
        x_arrival = x.stop_times.order(:index).first.arrival
        y_arrival = y.stop_times.order(:index).first.arrival
        x_arrival <=> y_arrival
      end
      @route_trips[r.id] = trips
    end
  end
end
