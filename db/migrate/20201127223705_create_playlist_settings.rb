class CreatePlaylistSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :playlist_settings do |t|
      t.string :playlist_id
      t.jsonb :settings

      t.timestamps
    end
  end
end
