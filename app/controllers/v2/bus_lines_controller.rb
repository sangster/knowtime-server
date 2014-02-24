module V2
  class BusLinesController < ApplicationController
    def index
      @bus_lines = BusLine.all
    end
  end
end
