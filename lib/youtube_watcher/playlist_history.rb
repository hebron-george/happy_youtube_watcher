module PlaylistHistory
  # @param [Array[PlaylistSnapshot]]sorted_snapshots
  # @return [Array[Hash]]
  #
  # Returns an array of hashes that represent the changes over time
  # [
  #   {
  #     snapshot_date: "Fri, 18 Jun 2021 14:00:23 UTC +00:00,
  #     added: [], # i.e. no new songs added on this date
  #     removed: [{video_id: 'xxx', title: 'xxx'}, {video_id: yyy, title: 'yyy'}],
  #   },
  #   {
  #     snapshot_date: "Sat, 19 Jun 2021 14:00:23 UTC +00:00",
  #     added: [], # i.e. no new songs added on this date
  #     removed: [{video_id: 'xxx', title: 'xxx'}, {video_id: yyy, title: 'yyy'}],
  #   },
  # ]
  def self.get_playlist_history(sorted_snapshots)
    history = []
    sorted_snapshots.each_cons(2) do |snapshot1, snapshot2|
      changes = PlaylistSnapshot.calculate_diffs(snapshot1.playlist_items, snapshot2.playlist_items)
      history << {
        snapshot_date: snapshot2.created_at,
        added:         changes[:added],
        removed:       changes[:removed],
      }
    end
  end
end
