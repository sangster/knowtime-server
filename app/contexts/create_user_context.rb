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
class CreateUserContext
  include Context

  role :data
  role :url_provider

  def act
    create_user.tap do |user|
      add_location user
    end
  end

  private

  def create_user
    User.new.tap do |user|
      user.data_set_id = data.id
      user.save!
      user.reload
    end
  end

  def add_location(user)
    class << user
      attr_accessor :location
    end

    user.location = url_provider.user_url data_set_id: user.data_set_id,
                                                   id: user.uuid
  end
end
