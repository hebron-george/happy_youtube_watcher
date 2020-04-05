class AddIndexToTrackedPlaylistPlaylistId < ActiveRecord::Migration[5.2]
  def change
    add_index :tracked_playlists, :playlist_id, :unique => true
  end
end
