class StopsController < ApplicationController

  def index
    @stops = Stop.order :stop_number
  end


  def show
    @stop = get_stop_or_raise params[:stop_number]
  end


  def show_with_trip_uuids
    @stop = get_stop_or_raise params[:stop_number]
  end


  private


  def get_stop_or_raise stop_number
    stop = Stop.find_by_stop_number stop_number
    raise ActiveRecord::RecordNotFound if stop.nil?
    stop
  end
end
