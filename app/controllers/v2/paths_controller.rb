module V2
  class PathsController < ApplicationController
    def show
      @path = ::Path.find params[:id]
    end
  end
end
