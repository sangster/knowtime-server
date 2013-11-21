BustedRuby::Application.routes.draw do

  scope '/api/alpha_1/', {defaults: {format: 'json'}} do
    get 'stops', to: 'stops#index'
    get 'stop/:stop_number', to: 'stops#show'
    get 'stop/:stop_number/trips', to: 'stops#show_with_trip_uuids'

    get 'stoptimes/:stop_number/:year-:month-:day', to: 'stop_times#visitors_for_stop_and_date'

    get 'path/:path_uuid', to: 'paths#show'
    get 'paths/:year-:month-day/:route_uuid', to: 'paths#show_for_route_and_date'

    get 'routes', to: 'routes#index'

    get 'calendars/:year-:month-:day', to: 'calendars#index_for_date'

    get 'pollrate', to: 'user_configurations#pollrate'
  end

end
