class AddIsDefaultColumnToTrackedPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_column :tracked_playlists, :is_default, :boolean
    add_index :tracked_playlists, :is_default
  end
end
