class CalendarsController < ApplicationController
  def index_for_date
    @calendars = Calendar.for_date_params params
  end
end
