class RoutesController < ApplicationController
  def index
    @routes = Route.all
  end


  def names
    @names = Route.names
  end
end
