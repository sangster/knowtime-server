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
BustedRuby::Application.routes.draw do
  scope '/v2/', defaults: {format: :json} do
    mount GtfsEngine::Engine, at: '/gtfs'

    resources :data_sets, only: [:index, :show]

    scope ':data_set_id' do
      resources :stops, only: [] do
        collection do
          post :within_bounds
        end
      end

      resources :routes, only:[] do
        collection do
          get ':date/stop/:stop_id', action: :for_stop, as: :routes_for_stop
        end
      end
    end
  end
end
