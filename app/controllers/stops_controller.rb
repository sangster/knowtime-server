class StopsController < ApplicationController
  def within_bounds
    @collection = GetStopsWithinBoundsContext.new \
      .set_stops(data.stops)
      .set_bounds(within_params) \
      .call

    respond_to do |format|
      format.json { render 'gtfs_engine/gtfs/index' }
    end
  end

  def within_params
    params.tap do |p|
      p.require :lat1
      p.require :lat2
      p.require :lon1
      p.require :lon2
    end
  end
end
