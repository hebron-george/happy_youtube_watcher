class StatsController < ApplicationController
  def index
    @songs_in_playlists = songs_in_playlists
  end

  private

  def songs_in_playlists
    TrackedPlaylist.all.inject({}) { |acc, tp| acc[tp.name] = tp.playlist_snapshots.newest.working_songs.count; acc }
  end
end
