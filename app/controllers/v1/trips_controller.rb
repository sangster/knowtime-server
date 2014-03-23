class V1::TripsController < V1::ApplicationController
  def show
    @trip = Trip.find_by trip_id: params[:trip_id]
    render_error :not_found, "no trip found for ID: #{params[:trip_id]}" if @trip.nil?
  end
end
