class V1::RoutesController < V1::ApplicationController
  def index
    @routes = Route.all
  end

  def headsigns_at_time
    calendars = Calendar.for_date_params(params)
    query_with_headsigns calendars, params[:value]
    @minutes = params[:hours].to_i * 60 + params[:minutes].to_i
  end

  private

  def query_with_headsigns(calendars, name)
    @routes = Route.where route_short_name: name

    @route_trips = {}
    @routes.each do |r|
      trips = r.trips.where service_id: calendars.collect( &:service_id )

      puts "\n\n\n\n trips: #{trips.length}\n\n\n"
      @route_trips[r.id] = trips.sort! do |x, y|
        x_arrival = x.stop_times.first.arrival
        y_arrival = y.stop_times.first.arrival
        x_arrival <=> y_arrival
      end
    end
  end
end
