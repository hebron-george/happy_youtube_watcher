require 'yt'

class PlaylistSnapshot < ApplicationRecord
  BROKEN_STATUSES = ['Deleted video', 'Private video']

  # attr_accessor :playlist_id, :channel_id, :playlist_items

  def self.capture_all_tracked_playlists!
    TrackedPlaylist.all.each { |tp| create_snapshot!(tp.playlist_id) }
  end

  def self.create_snapshot!(playlist_id)
    playlist       = Yt::Playlist.new(id: playlist_id)
    channel_id     = playlist.channel_id
    all_songs      = playlist.playlist_items.where;
    playlist_items = {}

    all_songs.each do |song|
      song_id = song.snippet.data['resourceId']['videoId']
      playlist_items[song_id] = song.snippet.data
    end

    ps = PlaylistSnapshot.new
    ps.playlist_id = playlist_id
    ps.channel_id  = channel_id
    ps.playlist_items = playlist_items
    ps.save!
  end

  def broken_songs
    playlist_items.select do |_song_id, song|
      BROKEN_STATUSES.include?(song['title'])
    end
  end
end
