class PlaylistSettingsController < ApplicationController
    def create
        # returns the first item or nil.
        playlist_setting = PlaylistSetting.find_by(playlist_id: playlist_setting_params[:playlist_id])

        if playlist_setting.nil?
            playlist_setting = PlaylistSetting.new(playlist_id: playlist_setting_params[:playlist_id], settings: {})
        end

        playlist_setting.settings.merge!(playlist_setting_params[:settings])

        playlist_setting.save!
    end

    private

    def playlist_setting_params
        params.require(:playlist_setting).permit(:playlist_id, { settings: { videos: [:video_id, :start, :end, :volume] } })
    end
end
