class EstimationsController < ApplicationController
  def index_for_short_name
    now = Time.zone.at( DateTime.now ).time
    short_name = params[:short_name]

    @estimations = BusEstimation.locations_and_next_stops short_name, now, 
                     duration: 30.minutes
  end

  def index_for_short_name_within_area
    now = Time.zone.at( DateTime.now ).time
    short_name = params[:short_name]

    loc_1 = Location.new params[:lat1].to_f, params[:lng1].to_f
    loc_2 = Location.new params[:lat2].to_f, params[:lng2].to_f
    bounds = LocationBounds.new( loc_1, loc_2 )

    @estimations = BusEstimation.locations_and_next_stops short_name, now, 
                     duration: 30.minutes, bounds: bounds
  end
end
