require 'yt'
require 'youtube_watcher/slacker'

class PlaylistSnapshot < ApplicationRecord
  BROKEN_STATUSES = ['Deleted video', 'Private video']

  # attr_accessor :playlist_id, :channel_id, :playlist_items

  def self.capture_all_tracked_playlists!
    TrackedPlaylist.all.each { |tp| ps = create_snapshot!(tp.playlist_id); post_diff!(ps); }
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

    ps
  end

  def self.post_diff!(snapshot)
    previous_snapshot = PlaylistSnapshot.where(playlist_id: snapshot.playlist_id).where("created_at < ?", snapshot.created_at).newest
    return unless previous_snapshot

    previous_songs = previous_snapshot.playlist_items.map { |_video_id, song| song.dig('title') }
    current_songs  = snapshot.playlist_items.map { |_vid, song| song.dig('title') }

    diffs = calculate_diffs(current_songs, previous_songs)
    message = create_diff_message(diffs, snapshot.playlist_id)

    ::YoutubeWatcher::Slacker.post_message(message, '#happy-hood')
  end

  def self.calculate_diffs(current_songs, previous_songs)
    {
      removed: previous_songs - current_songs,
      added:   current_songs - previous_songs
    }
  end

  def self.create_diff_message(diffs, playlist_id)
    s = [""]
    s += ["These songs were removed:\n ```#{diffs[:removed].join("\n")}```"] if diffs[:removed].any?
    s += ["These songs were added:\n```#{diffs[:added].join("\n")}```"] if diffs[:added].any?
    s = s.join("\n")

    return s if s.length.zero?

    s = "Playlist (https://youtube.com/playlist?list=#{playlist_id}) - #{Date.today.readable_inspect}\n\n" + s
  end

  def broken_songs
    playlist_items.select do |_song_id, song|
      BROKEN_STATUSES.include?(song['title'])
    end
  end

  def working_songs
    playlist_items.reject do |_song_id, song|
      BROKEN_STATUSES.include?(song['title'])
    end
  end

  def shuffled_working_songs
    keys = working_songs.keys.shuffle
    results = []
    keys.each do |k|
      song = working_songs[k]
      results << {
        title:    song.dig('title'),
        video_id: k,
      }
    end
    results
  end
end
