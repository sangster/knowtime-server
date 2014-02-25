module V2
  class RoutesController < ApplicationController
    def index
      @routes = Route.all
    end

    def show
      @route = Route.find params[:id]
      render_error :not_found, "no route found for UUID: #{params[:id]}" if @route.nil?
    end
  end
end
