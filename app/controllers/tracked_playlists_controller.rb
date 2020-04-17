class TrackedPlaylistsController < ApplicationController
  def index
    tps = TrackedPlaylist.all.map { |tp| {playlist_id: tp.playlist_id, name: tp.name, is_default: tp.is_default} }.sort_by { |tp| tp[:name] }
    json_response(tps)
  end

  def create
    playlist_info = Yt::Playlist.new(id: params[:playlist_id])

    tp = TrackedPlaylist.create!(
      playlist_id: params[:playlist_id],
      name:        "#{playlist_info.channel_title} - #{playlist_info.title}",
      is_default:  !!params[:is_default]
    )

    json_response(tp, :created)
  end
end
