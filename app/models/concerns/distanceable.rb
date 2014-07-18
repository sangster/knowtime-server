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
module Distanceable
  extend ActiveSupport::Concern

  EARTH_DIAMETER = 1.2735e7; # in meters

  def distance_from other
    lat2 = other.lat
    lng2 = other.lng

    d_lat = to_radians (lat2 - lat)
    d_lng = to_radians (lng2 - lng)

    sin_d_lat = Math.sin (d_lat / 2)
    sin_d_lng = Math.sin (d_lng / 2)

    a = (sin_d_lat ** 2) + (sin_d_lng ** 2) * Math.cos(to_radians(lat)) * Math.cos(to_radians(lat2))
    (EARTH_DIAMETER * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))).abs
  end


  private


  def to_radians degrees
    degrees * Math::PI / 180
  end
end
