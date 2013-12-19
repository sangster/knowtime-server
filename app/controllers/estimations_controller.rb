class EstimationsController < ApplicationController
  def index_for_short_name
    now = Time.zone.at( DateTime.now ).time
    short_name = params[:short_name]
    
    @estimations = BusEstimation.locations_and_next_stops short_name, now, 30.minutes
  end
end
