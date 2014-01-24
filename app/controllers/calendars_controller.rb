class CalendarsController < ApplicationController
  def show
    @calendar = Calendar.for_uuid params[:calendar_uuid]
    render_error :not_found, "no calendar found for UUID: #{params[:calendar_uuid]}" if @calendar.nil?
  end


  def index_for_date
    @calendars = Calendar.for_date_params params
  end

  def table
    cal = Calendar.for_date( time_from_params ).first
    @tables = {}

    cal.trip_groups( params[:short_name] ).each_pair do |heading,trips|
      @tables[heading] = CalendarTable.new heading, trips
    end
  end
end
