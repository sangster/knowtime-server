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
class UsersController < ApplicationController
  def show
    raw_user = data.users.find_by! uuid: params[:id]

    @user =
      GetUserContext.call do |ctx|
        ctx.set_user raw_user
        ctx.set_data data
      end

    respond_with @user
  end

  def create
    @user =
      CreateUserContext.call do |ctx|
        ctx.set_data data
        ctx.set_url_provider self
      end

    respond_with @user, status: 201, location: @user.location
  end
end
