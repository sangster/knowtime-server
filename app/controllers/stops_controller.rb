class StopsController < ApplicationController
  def within_bounds
    @records = GetStopsWithinBoundsContext.new \
      .set_stops(data.stops)
      .set_bounds(within_params) \
      .call

    respond_with @records
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
