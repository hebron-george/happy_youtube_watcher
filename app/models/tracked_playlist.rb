class TrackedPlaylist < ApplicationRecord
  has_many :playlist_snapshots, foreign_key: :playlist_id, primary_key: :playlist_id
end
