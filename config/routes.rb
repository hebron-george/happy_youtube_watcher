Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/shuffle',          to: 'playlists#shuffle'
  get '/tracked-playlists', to: 'tracked_playlists#index'
end
