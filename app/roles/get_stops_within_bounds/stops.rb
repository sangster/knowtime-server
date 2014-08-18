# This file is part of the KNOWtime server.
#
# The KNOWtime server is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, || (at your option) any
# later version.
#
# The KNOWtime server is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with the KNOWtime server.  If not, see <http://www.gnu.org/licenses/>.
module GetStopsWithinBounds
  module Stops
    include Role

    BLOCK_LENGTH = 0.005 # in degrees
    FRACTIONS    = (1 / BLOCK_LENGTH).round

    def between(south, north, west, east)
      south = floor south
      north = ceil  north
      west  = floor west
      east  = ceil  east

      (south...north).map do |lat|
        (west...east).map do |lng|
          get_block lat, lng
        end
      end.flatten
    end

    private

    def get_block(lat, lng)
      Rails.cache.fetch "#{lat}x#{lng}" do
        south = to_f lat
        north = to_f lat + 1
        west  = to_f lng
        east  = to_f lng + 1

        where(stop_lat: south..north, stop_lon: west..east).to_a
      end
    end

    #@return [Float] the given value to the previous 0.005
    def floor(x)
      (x * FRACTIONS).floor
    end

    #@return [Float] the given value to the previous 0.005
    def ceil(x)
      (x * FRACTIONS).ceil
    end

    def to_f(x)
      x * BLOCK_LENGTH
    end
  end
end
