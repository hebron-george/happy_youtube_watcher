require 'rails_helper'

RSpec.describe PlaylistSnapshot do
  describe '.capture_all_tracked_playlists!' do
    subject { described_class.capture_all_tracked_playlists! }

    before do
      TrackedPlaylist.all.each(&:destroy)
      TrackedPlaylist.create(playlist_id: 'playlist_id', name: 'channelname')
      PlaylistSnapshot.create(playlist_id: 'playlist_id', playlist_items: {})
      allow(described_class).to receive(:get_playlist_items_from_yt).and_return(mocked_yt_response)
    end

    after do
      TrackedPlaylist.all.each(&:destroy)
      PlaylistSnapshot.all.each(&:destroy)
    end

    let(:mocked_yt_response) do
      {
        'song_1' => {'title'=>'song_1_title',
                     'complete'=>true,
                     'position'=>259,
                     'channelId'=>'playlist_owner_channel_id',
                     'playlistId'=>'playlist_id',
                     'resourceId'=>{'kind'=>'youtube#video', 'videoId'=>'song_1'},
                     'thumbnails'=> {},
                     'description'=>'some description string',
                     'publishedAt'=>'2019-01-03T21:58:39Z',
                     'channelTitle'=>'channelTitle',
                     'videoOwnerChannelId'=>'channelid',
                     'videoOwnerChannelTitle'=>'channelname'}
      }
    end

    it 'takes a snapshot with diffs and posts to slack' do
      expect { subject }.to change { PlaylistSnapshot.count }.by(1)
      expect(YoutubeWatcher::Slacker).to receive(:post_message)
      subject
    end
  end
end
