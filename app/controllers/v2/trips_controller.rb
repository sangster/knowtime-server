module V2
  class TripsController < ApplicationController
    def show
      @trip = Trip.find params[:id]
      render_error :not_found, "no trip found for UUID: #{params[:id]}" if @trip.nil?
    end
  end
end
