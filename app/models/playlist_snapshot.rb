require 'yt'

class PlaylistSnapshot < ApplicationRecord
  BROKEN_STATUSES = ['Deleted video', 'Private video']

  # attr_accessor :playlist_id, :channel_id, :playlist_items
  def self.create_snapshot!
    playlist_id = 'FL7B_s7wxX-D__fkTiYp3Oaw'
    channel_id  = 'UC7B_s7wxX-D__fkTiYp3Oaw'

    all_songs = Yt::Playlist.new(id: playlist_id).playlist_items.where;
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