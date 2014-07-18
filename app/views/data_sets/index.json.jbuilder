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
json.ignore_nil! true

json.status 'success'
json.data do
  json.set! 'data_sets' do
    json.array! @data_sets do |data_set|
      json.extract! data_set, *%i(id name title)
      json.last_updated data_set.last_updated

      json.min do
        json.lat data_set.min_lat
        json.lon data_set.min_lon
      end
      json.max do
        json.lat data_set.max_lat
        json.lon data_set.max_lon
      end

      unless data_set.start_date.nil? || data_set.end_date.nil?
        json.dates do
          json.start data_set.start_date
          json.end data_set.end_date
        end
      end
    end
  end
end
