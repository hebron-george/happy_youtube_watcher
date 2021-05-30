class MoveChannelIdToTrackedPlaylists < ActiveRecord::Migration[6.0]
  def change
    execute "UPDATE tracked_playlists t, playlist_snapshots s SET t.channel_id = s.channel_id WHERE t.playlist_id = s.playlist_id"

    remove_column :playlist_snapshots, :channel_id, :string
  end
end
