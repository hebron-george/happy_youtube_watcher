require 'rails_helper'
require 'rspec'

describe PlaylistSnapshot do
  context '.calculate_diffs' do
    subject { PlaylistSnapshot.calculate_diffs(current_songs, previous_songs) }

    let(:current_songs) do
      {
        song_id_1: {song_info: {name: 'song1'}},
        song_id_2: {song_info: {name: 'song2'}},
        song_id_3: {song_info: {name: 'hayramloozrs'}},
      }
    end

    let(:previous_songs) do
      {
        song_id_1: {song_info: {name: 'song1'}},
        song_id_2: {song_info: {name: 'song2'}},
        song_id_4: {song_info: {name: 'ayylmao'}},
      }
    end

    let(:expected_removed) { [{song_info: {name: 'ayylmao'}}] }
    let(:expected_added)   { [{song_info: {name: 'hayramloozrs'}}] }

    it 'succeeds' do
      expect(subject).to eq({added: expected_added, removed: expected_removed})
    end
  end
end