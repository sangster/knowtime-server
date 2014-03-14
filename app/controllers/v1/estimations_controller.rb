class V1::EstimationsController < V1::ApplicationController
  def index_for_short_name
    short_name = params[:short_name]

    @estimations = BusEstimation.locations_and_next_stops short_name, time_from_params,
                     duration: 30.seconds
  end

  def active_lines
    opts = { time: time_params? ? time_from_params : nil, duration: params[:duration] }
    opts.delete_if {|k, value| value.nil? }
    opts[:duration] = opts[:duration].to_i.minutes if opts[:duration]
    @lines = BusEstimation.active_lines opts
  end
end
