Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/shuffle',           to: 'playlists#shuffle'
  get '/tracked-playlists',  to: 'tracked_playlists#index'
  post '/tracked-playlists', to: 'tracked_playlists#create'
  post '/playlist-settings', to: 'playlist_settings#create'

  get '/videos',             to: 'videos#index'

  get '/stats',              to: 'stats#index'
end
