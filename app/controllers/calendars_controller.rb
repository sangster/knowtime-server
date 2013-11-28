class CalendarsController < ApplicationController
  def show
    @calendar = Calendar.for_uuid params[:calendar_uuid]
    render_error :not_found, "no calendar found for UUID: #{params[:calendar_uuid]}" if @calendar.nil?
  end


  def index_for_date
    @calendars = Calendar.for_date_params params
  end
end
