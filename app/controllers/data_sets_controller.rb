class DataSetsController < ApplicationController
  def index
    expires_in 3.hours

    @data_sets = Rails.cache.fetch "data_set_summaries" do
      GtfsEngine::DataSet.all.collect do |data_set|
        SummarizeDataSetContext.new \
          .set_data(data_set) \
          .call
      end
    end

    respond_with @data_sets
  end

  def show

  end
end
