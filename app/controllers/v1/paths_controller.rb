class V1::PathsController < V1::ApplicationController
  respond_to :json

  def show
    @path = Shape.path params[:shape_id]

    if @path
      respond_with @path
    else
      render_error :not_found, "no path found for ID: #{params[:path_id]}" .nil?
    end
  end


  def index_for_route_and_date
    calendars = Calendar.for_date_params params
    unless calendars and calendars.any?
      render_error :not_found, 'no calendars found for given date'
      return
    end

    sids = Trip.where( route_id: params[:route_id],
                       service_id: calendars.collect(&:service_id) )
            .distinct.pluck :shape_id

    @paths = sids.collect {|shape_id| Shape.path shape_id }
    respond_with @paths
  end
end
