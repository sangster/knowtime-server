class StopsController < ApplicationController

  def index
    @stops = Stop.all.sort_by &:stop_number
  end

  def show
    @stop = get_stop_or_raise params[:stop_number]
  end

  def show_with_trip_uuids
    @stop = get_stop_or_raise params[:stop_number]
  end

  private

  def get_stop_or_raise(stop_number)
    stop = Stop.find stop_number
    render_error :not_found, "no stop with number #{stop_number}" if stop.nil?
    stop
  end
end
