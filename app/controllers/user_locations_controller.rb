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
class UserLocationsController < ApplicationController
  def index
    @locations =
      GetUserLocationsContext.call do |ctx|
        ctx.set_user user
      end
  end

  def create
    CreateUserLocationContext.call do |ctx|
      ctx.set_user user
      ctx.set_location location_params
    end

    render nothing: true, status: :created
  end

private

  def user
    User.find_by! uuid: params[:user_id], data_set_id: data.id
  end

  def location_params
    params.tap do |p|
      p.require :lat
      p.require :lon
    end
  end
end
