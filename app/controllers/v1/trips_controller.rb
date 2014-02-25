class V1::TripsController < V1::ApplicationController
  def show
    @trip = Trip.for_uuid params[:trip_uuid]
    render_error :not_found, "no trip found for UUID: #{params[:trip_uuid]}" if @trip.nil?
  end
end
