class PlaylistsController < ApplicationController
  # <iframe src='https://www.youtube.com/embed/<%= @episode.youtube_id %>?rel=0&autoplay=<%= params[:autoplay] || 0 %>' frameborder='0' allowfullscreen></iframe>

  # Shuffle's a given youtube playlist for you
  def shuffle
    @playlist = PlaylistSnapshot.where(playlist_id: params[:playlist_id]).newest

    json_response({error_message: 'We could not find that playlist', playlist_id: params[:playlist_id]},:not_found) and return unless @playlist

    shuffled_video_list = {
      video_ids: @playlist.working_songs.keys.shuffle,
    }

    json_response(shuffled_video_list)
  end
end
