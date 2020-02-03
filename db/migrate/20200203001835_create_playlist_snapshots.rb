class CreatePlaylistSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_snapshots do |t|
      t.string :playlist_id
      t.string :channel_id
      t.jsonb :playlist_items

      t.timestamps
    end
  end
end
