class StopsController < ApplicationController

  def index
    @stops = Stop.all_by_stop_number
  end

  def show
    @stop = get_stop_or_raise params[:stop_number]
  end

  def show_with_trip_uuids
    @stop = get_stop_or_raise params[:stop_number]
  end

  def next_stops
    @next_stops = StopTime.next_stops params[:short_name], time_from_params
  end

  private

  def get_stop_or_raise(stop_number)
    Stop.find stop_number
  rescue
    render_error :not_found, "no stop with number #{stop_number}"
  end
end
