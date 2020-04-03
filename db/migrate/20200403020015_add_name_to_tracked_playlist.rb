class AddNameToTrackedPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_column :tracked_playlists, :name, :string
    add_index :tracked_playlists, :name
  end
end
