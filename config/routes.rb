float_regex = /[-+]?[0-9]*\.?[0-9]*/

BustedRuby::Application.routes.draw do

  scope '/alpha_1/', {defaults: {format: 'json'}} do
    get 'stop/:stop_number', to: 'stops#show'
    get 'stop/:stop_number/trips', to: 'stops#show_with_trip_uuids'
    get 'stops', to: 'stops#index'

    get 'stoptimes/:stop_number/:year-:month-:day', to: 'stop_times#visitors_for_stop_and_date'

    get 'path/:path_uuid', to: 'paths#show'
    get 'paths/:year-:month-:day/:route_uuid', to: 'paths#index_for_route_and_date'

    get 'route/:route_uuid', to: 'routes#show'
    get 'route/:route_uuid/:year-:month-:day', to: 'routes#show_with_trips_on_date'
    get 'routes', to: 'routes#index'
    get 'routes/names', to: 'routes#names'
    get 'routes/:short_name/:year-:month-:day', to: 'routes#index_for_short_name_and_date'
    get 'routes/:key::value', to: 'routes#index_by_query'
    get 'routes/:key::value/headsigns/:year-:month-:day', to: 'routes#index_by_query_with_headsigns'
    get 'routes/date::year-:month-:day/headsigns', to: 'routes#index_by_date_with_headsigns'
    get 'routes/:key::value/headsigns/:year-:month-:day/:hours::minutes',
        to: 'routes#index_by_query_and_time_with_headsigns'
    get 'routes/date::year-:month-:day/headsigns/:hours::minutes', to: 'routes#index_by_date_and_time_with_headsigns'

    get 'trip/:trip_uuid', to: 'trips#show'

    get 'calendar/:calendar_uuid', to: 'calendars#show'
    get 'calendars/:year-:month-:day', to: 'calendars#index_for_date'

    get 'pollrate', to: 'user_configurations#pollrate'
    get 'check_remote_zip/e349aa6b-dc8d-37af-9695-75a9093e78e7', to: 'user_configurations#check_remote_zip'

    post 'users/new/:short_name', to: 'users#create'
    post 'user/:user_uuid', to: 'users#create_location'
    get 'user/:user_uuid', to: 'users#show'
    get 'users', to: 'users#index'

    get 'estimates/short::short_name', to: 'estimations#index_for_short_name'
    get 'estimates/short::short_name/:lat1::lng1/:lat2::lng2', to: 'estimations#index_for_short_name_within_area',
      constraints: { lat1: float_regex, lng1: float_regex, lat2: float_regex, lng2: float_regex }
  end

end
