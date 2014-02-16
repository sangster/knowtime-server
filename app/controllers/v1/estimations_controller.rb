class V1::EstimationsController < V1::ApplicationController
  def index_for_short_name
    short_name = params[:short_name]

    @estimations = BusEstimation.locations_and_next_stops short_name, time_from_params,
                     duration: 5.minutes
  end

  def index_for_short_name_within_area
    short_name = params[:short_name]

    bounds = LocationBounds.new Location.new( params[:lat1].to_f, params[:lng1].to_f ),
                                Location.new( params[:lat2].to_f, params[:lng2].to_f )

    @estimations = BusEstimation.locations_and_next_stops short_name, time_from_params,
                    duration: 5.minutes, bounds: bounds
  end

  def active_lines
    opts = { time: time_params? ? time_from_params : nil, duration: params[:duration] }
    opts.delete_if {|k, value| value.nil? }
    opts[:duration] = opts[:duration].to_i.minutes if opts[:duration]
    @lines = BusEstimation.active_lines opts
  end
end