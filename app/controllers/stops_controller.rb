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
class StopsController < ApplicationController
  # Returns a list of stops within a given area. The area is delimited by two
  # GPS points POSTed with 4 params: (:lat1, :lon1), (:lat2, :lon2)
  def within_bounds
    @stops = GetStopsWithinBoundsContext.call do |ctx|
      ctx.set_stops data.stops
      ctx.set_bounds within_params
    end

    respond_with @stops
  end

  def within_params
    params.tap do |p|
      p.require :lat1
      p.require :lat2
      p.require :lon1
      p.require :lon2
    end
  end
end
