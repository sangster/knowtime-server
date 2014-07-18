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
class RoutesController < ApplicationController
  # rescue_from GtfsEngine::DateFormatError, with: :jsend_fail_bad_date

  # Returns a list of routes which stop at the given stop on the given date
  def for_stop
    expires_in 3.hours

    @routes =
      data_cache "[#{params[:date]}]_routes_for_stop[#{params[:stop_id]}]" do
        GetRoutesForStopContext.new \
          .set_calendars( params ) \
          .set_stop( GtfsEngine::Stop.new stop_id: params[:stop_id] )
          .set_routes( data.routes ) \
          .set_data( data ) \
          .call
      end
    respond_with @routes
  end

  private

  def jsend_fail_bad_date
    jsend_fail data: {date: 'not in expected format: YYYY-MM-DD'}
  end
end
