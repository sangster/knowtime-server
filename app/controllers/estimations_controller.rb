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

    bounds = LocationBounds.new Location.new( params[:lat1].to_f, params[:lng1].to_f ),
                                Location.new( params[:lat2].to_f, params[:lng2].to_f )

    @estimations = BusEstimation.locations_and_next_stops short_name, now, 
                     duration: 30.minutes, bounds: bounds
  end
end
