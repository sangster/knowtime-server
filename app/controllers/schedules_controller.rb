class SchedulesController < ApplicationController
  def show
    @short_name = params[:short_name]
    @date = time_from_params
    @schedules = {}


    cal = Calendar.for_date( @date ).first
    cal.trip_groups( @short_name ).each_pair do |heading,trips|
      @schedules[heading] = CalendarTable.new heading, trips
    end
  end
end
