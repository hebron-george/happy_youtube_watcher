class PlaylistsController < ApplicationController
  # <iframe src='https://www.youtube.com/embed/<%= @episode.youtube_id %>?rel=0&autoplay=<%= params[:autoplay] || 0 %>' frameborder='0' allowfullscreen></iframe>

  # Shuffle's a given youtube playlist for you
  def shuffle
    playlist_ids = params[:playlist_ids].blank? ? TrackedPlaylist.where(:is_default => true).pluck(:playlist_id) : params[:playlist_ids]
    shuffled_video_list = {
      songs: PlaylistSnapshot.shuffle_playlists(playlist_ids),
    }

    json_response(shuffled_video_list)
  end
end
