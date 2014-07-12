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
module SummarizeDataSet
  module Data
    include Role

    def last_updated
      @last_updated ||= created_at.strftime '%FT%R%z'
    end

    def min_lat
      @min_lat ||= (shapes.minimum :shape_pt_lat or -90.0)
    end

    def min_lon
      @min_lon ||= (shapes.minimum :shape_pt_lon or -180.0)
    end

    def max_lat
      @max_lat ||= (shapes.maximum :shape_pt_lat or 90.0)
    end

    def max_lon
      @max_lon ||= (shapes.maximum :shape_pt_lon or 180.0)
    end

    def start_date
      @start_date ||= [calendar_start, calendar_date_start].min
    end

    def end_date
      @end_date ||= [calendar_end, calendar_date_end].max
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
