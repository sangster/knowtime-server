module V2
  class TripGroupsController < ApplicationController
    def index
      @groups = TripGroup.all
    end

    def show
      @group = TripGroup.find params[:id]
    end
  end
end
