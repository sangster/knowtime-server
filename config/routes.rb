BustedRuby::Application.routes.draw do
  scope '/v2/', defaults: {format: :json} do
    mount GtfsEngine::Engine, at: '/gtfs'

    resources :data_sets, only: [:index, :show]
  end
end
