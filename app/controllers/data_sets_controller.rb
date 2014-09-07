# This file is part of the KNOWtime server.
#
# The KNOWtime server is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# The KNOWtime server is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with the KNOWtime server.  If not, see <http://www.gnu.org/licenses/>.
class DataSetsController < ApplicationController
  def index
    expires_in 3.hours

    @data_sets = Rails.cache.fetch "data_set_summaries" do
      sets = {}
      GtfsEngine::DataSet.order(:created_at).collect do |data_set|
        SummarizeDataSetContext.call { |ctx| ctx.set_data data_set }
      end.each do |data_set|
        sets[data_set.name] = data_set
      end
      sets.values
    end

    respond_with @data_sets
  end

  def show

  end
end
