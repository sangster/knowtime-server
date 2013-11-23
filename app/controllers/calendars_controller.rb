class CalendarsController < ApplicationController
  def show
    @calendar = Calendar.for_uuid params[:calendar_uuid]
  end


  def index_for_date
    @calendars = Calendar.for_date_params params
  end
end
