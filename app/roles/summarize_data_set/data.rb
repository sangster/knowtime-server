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
module SummarizeDataSet
  module Data
    include Role

    attr_accessor :last_updated, :min_lat, :min_lon, :max_lat, :max_lon,
                  :start_date, :end_date

    def on_role_assignment
      self.last_updated = created_at.strftime '%FT%R%z'
      self.min_lat = stops.minimum(:stop_lat) || -90.0
      self.min_lon = stops.minimum(:stop_lon) || -180.0
      self.max_lat = stops.maximum(:stop_lat) || 90.0
      self.max_lon = stops.maximum(:stop_lon) || 180.0
      self.start_date = [calendar_start, calendar_date_start].min
      self.end_date = [calendar_end, calendar_date_end].max
    end

    private

    def calendar_start
      calendars.minimum :start_date
    end

    def calendar_end
      calendars.maximum :end_date
    end

    def calendar_date_start
      calendar_dates.minimum :date
    end

    def calendar_date_end
      calendar_dates.maximum :date
    end
  end
end
