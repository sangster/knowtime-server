class V1::RoutesController < V1::ApplicationController
  def index
    @routes = Rails.cache.fetch("routes_index", eternal: true) { Route.all }
  end

  def headsigns_at_time
    calendars = Calendar.for_date_params(params)
    query_with_headsigns calendars, params[:value]
    @minutes = params[:hours].to_i * 60 + params[:minutes].to_i
  end

  private

  def query_with_headsigns(calendars, name)
    @routes = Route.where route_short_name: name
    sids = calendars.distinct.pluck( :service_id )

    @route_trips =
      Rails.cache.fetch "q_w_h_#{@routes.collect &:route_id}_#{sids}",
                        eternal: true do
        {}.tap do |rt|
          @routes.each do |r|
            trips = r.trips.where(service_id: sids).to_a
            rt[r.id] = trips
          end
        end
      end
  end
end
