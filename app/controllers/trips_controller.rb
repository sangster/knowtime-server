class TripsController < ApplicationController
  def show
    @trip = Uuid.find_idable params[:trip_uuid]
    raise ActiveRecord::RecordNotFound if @trip.nil?
  end
end
