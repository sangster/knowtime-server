class DataSetsController < ActionController::Base
  include GtfsEngine::Concerns::Controllers::DataAccess
  respond_to :json

  def index
    @data_sets = GtfsEngine::DataSet.all.collect do |data_set|
      SummarizeDataSetContext.new.set_data(data_set).call
    end

    respond_with @data_sets
  end

  def show

  end
end
