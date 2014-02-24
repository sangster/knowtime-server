module V2
  class CalendarsController < ApplicationController
    def index
      @calendars = ::Calendar.not_ferry
    end

    def show
      @calendar = ::Calendar.find params[:id]
    end
  end
end
