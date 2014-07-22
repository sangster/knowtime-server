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
GtfsEngine.sources do |s|
  s.halifax_localhost do
    title 'Halifax Metro (test)'
    url METRO_TRANSIT['zip_url']
  end
  s.halifax do
    title 'Halifax Metro'
    url 'http://www.halifax.ca/metrotransit/googletransitfeed/google_transit.zip'
  end
  s.edmonton do
    title "Edmonton Transit System"
    url 'http://webdocs.edmonton.ca/transit/etsdatafeed/google_transit.zip'
  end
  s.sample do
    title 'Google Sample Feed'
    url 'http://localhost/sample-feed.zip'
  end
end
