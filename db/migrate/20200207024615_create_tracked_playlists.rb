class CreateTrackedPlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :tracked_playlists do |t|
      t.string :playlist_id

      t.timestamps
    end
  end
end
