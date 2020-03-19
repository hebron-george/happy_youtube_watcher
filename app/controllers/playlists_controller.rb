class PlaylistsController < ApplicationController
  # <iframe src='https://www.youtube.com/embed/<%= @episode.youtube_id %>?rel=0&autoplay=<%= params[:autoplay] || 0 %>' frameborder='0' allowfullscreen></iframe>

  # Shuffle's a given youtube playlist for you
  def shuffle
    puts "At the beginning of the shuffle action!"
    playlist_ids = params[:playlist_ids]&.split(',')
    @playlists = PlaylistSnapshot.where(playlist_id: playlist_ids)
    json_response({error_message: 'Could not find the playlist(s)!', playlist_id: params[:playlist_id]},:not_found) and return unless @playlists

    shuffled_video_list = {
      songs: @playlists.map(&:shuffled_working_songs).flatten.compact.shuffle,
    }

    json_response(shuffled_video_list)
  end
end
