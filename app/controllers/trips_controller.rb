class TripsController < ApplicationController
  def show
    @trip = Trip.for_uuid params[:trip_uuid]
    raise ActiveRecord::RecordNotFound if @trip.nil?
  end
end
