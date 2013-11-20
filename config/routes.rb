BustedRuby::Application.routes.draw do

  scope '/api/alpha_1/', {defaults: {format: 'json'}} do
    get 'stops', to: 'stops#index'
    get 'stop/:stop_number', to: 'stops#show'
  end

end
