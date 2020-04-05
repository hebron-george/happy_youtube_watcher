class TrackedPlaylistsController < ApplicationController
  def index
    tps = TrackedPlaylist.all.map { |tp| {playlist_id: tp.playlist_id, name: tp.name, is_default: tp.is_default} }
    json_response(tps)
  end

  def create
    tp = TrackedPlaylist.create!(playlist_id: params[:playlist_id], name: params[:playlist_name])
    json_response(tp, :created)
  end
end
