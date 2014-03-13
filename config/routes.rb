float_regex = /[-+]?[0-9]*\.?[0-9]*/

BustedRuby::Application.routes.draw do
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

    get 'calendar/:calendar_uuid', to: 'calendars#show'
    get 'calendars/:year-:month-:day', to: 'calendars#index_for_date'

    get 'schedule/:short_name(.:format)', to: 'schedules#show'
    get 'schedule/:short_name(.:format)/nextstops', to: 'schedules#next_stops'

    get 'pollrate', to: 'user_configurations#pollrate'
    get 'check_remote_zip/:admin_uuid', to: 'user_configurations#check_remote_zip'

    post 'users/new/:short_name', to: 'users#create'
    post 'user/:uuid', to: 'users#create_location'
    get 'user/:uuid', to: 'users#show'
    get 'users', to: 'users#index'

    get 'estimates/short::short_name', to: 'estimations#index_for_short_name'
    get 'estimates/short::short_name/:lat1::lng1/:lat2::lng2', to: 'estimations#index_for_short_name_within_area',
      constraints: { lat1: float_regex, lng1: float_regex, lat2: float_regex, lng2: float_regex }
    get 'estimates/activelines', to: 'estimations#active_lines'
  end

end
