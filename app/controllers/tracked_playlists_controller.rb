class TrackedPlaylistsController < ApplicationController
  def index
    tps = TrackedPlaylist.all.map { |tp| {playlist_id: tp.playlist_id, name: tp.name, is_default: tp.is_default} }
    json_response(tps)
  end
end
