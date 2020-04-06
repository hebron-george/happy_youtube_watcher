class AddIndexPlaylistIdIndexToPlaylistSnapshot < ActiveRecord::Migration[5.2]
  def change
    add_index :playlist_snapshots, :playlist_id
  end
end
