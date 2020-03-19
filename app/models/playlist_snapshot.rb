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

    previous_songs = previous_snapshot.working_songs.dup.with_indifferent_access
    current_songs  = snapshot.working_songs.dup.with_indifferent_access

    diffs = calculate_diffs(current_songs, previous_songs)
    message = create_diff_message(diffs, snapshot.playlist_id)
    
    ::YoutubeWatcher::Slacker.post_message(message, '#happy-hood')
  end

  def self.calculate_diffs(current_songs, previous_songs)

    removed = previous_songs.reject { |k,_v| current_songs.key?(k) }.values.map(&:with_indifferent_access)
    added   = current_songs.reject  { |k,_v| previous_songs.key?(k) }.values.map(&:with_indifferent_access)
    {
      removed: removed,
      added:   added,
    }
  end

  def self.create_diff_message(diffs, playlist_id)
    s =  [""]
    s += ["These songs were removed:\n ```#{diffs[:removed].map { |song| "Position: #{song[:position]} - #{song[:title]}"}.join("\n")}```"] if diffs[:removed].any?
    s += ["These songs were added:\n```#{diffs[:added].map { |song| "Position: #{song[:position]} - #{song[:title]}"}.join("\n")}```"]      if diffs[:added].any?

    return '' unless s.count > 1 # Not just empty string

    s = s.join("\n")
    s = "Playlist (https://youtube.com/playlist?list=#{playlist_id}) - #{Date.today.readable_inspect}\n\n" + s
  end

  def self.shuffle_playlists(playlist_ids)
    playlists = playlist_ids.map { |id| PlaylistSnapshot.where(playlist_id: id).newest }.compact
    playlists.flat_map(&:shuffled_working_songs).compact.shuffle
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
