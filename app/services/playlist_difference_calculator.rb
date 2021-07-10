class PlaylistDifferenceCalculator
  def self.calculate_diffs(previous_songs, current_songs)
    removed = previous_songs.reject { |k,_v| current_songs.key?(k) }.values
    added   = current_songs.reject  { |k,_v| previous_songs.key?(k) }.values

    diffs = { removed: removed, added: added}
    new(diffs)
  end

  Song = Struct.new(:position, :title, :url, keyword_init: true)
  def initialize(diffs)
    @diffs = diffs
  end

  def any_changes?
    @diffs[:removed].any? || @diffs[:added].any?
  end

  def removed_songs
    @diffs[:removed].map { |song_details| create_song(song_details) }
  end

  def added_songs
    @diffs[:added].map { |song_details| create_song(song_details) }
  end

  private

  def create_song(song_details)
    position = song_details[:position]
    title = song_details[:title]
    url = "https://youtube.com/watch?v=#{song_details.dig(:resourceId, :videoId)}"
    Song.new(position: position, title: title, url: url)
  end
end
