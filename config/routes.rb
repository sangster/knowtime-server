BustedRuby::Application.routes.draw do

  scope '/api/alpha_1/', {defaults: {format: 'json'}} do
    get 'stops', to: 'stops#index'
    get 'stop/:stop_number', to: 'stops#show'
    get 'stop/:stop_number/trips', to: 'stops#show_with_trip_uuids'

    get 'calendars/:year-:month-:day', to: 'calendars#index_for_date'
  end

end
