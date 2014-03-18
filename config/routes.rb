float_regex = /[-+]?[0-9]*\.?[0-9]*/

BustedRuby::Application.routes.draw do
  scope '/v2/', module: :v2, defaults: {format: :json} do
    resources :bus_lines, only: [:index]
    resources :calendars, only: [:index, :show]
    resources :paths, only: [:show]
    resources :routes, only: [:index, :show]
    resources :trip_groups, only: [:index, :show]
    resources :trips, only: [:show]
  end

  scope '/alpha_1/', module: :v1, defaults: {format: 'json'} do
    get 'stops', to: 'stops#index'
    get 'stoptimes/:stop_id/:year-:month-:day',
        to: 'stop_times#visitors_for_stop_and_date'

    get 'path/:shape_id', to: 'paths#show'
    get 'paths/:year-:month-:day/:route_id', to: 'paths#index_for_route_and_date'

    get 'routes', to: 'routes#index'
    get 'routes/names', to: 'routes#index'
    get 'routes/short::value/headsigns/:year-:month-:day/:hours::minutes',
          to: 'routes#headsigns_at_time'

    get 'trip/:trip_id', to: 'trips#show'

    get 'schedule/:short_name(.:format)', to: 'schedules#show'
    get 'schedule/:short_name(.:format)/nextstops', to: 'schedules#next_stops'

    get 'pollrate', to: 'user_configurations#pollrate'

    post 'users/new/:short_name', to: 'users#create'
    post 'user/:uuid', to: 'users#create_location'
    get 'user/:uuid', to: 'users#show'
    get 'users', to: 'users#index'

    get 'estimates/short::short_name', to: 'estimations#index_for_short_name'
    get 'estimates/activelines', to: 'estimations#active_lines'
  end

end
