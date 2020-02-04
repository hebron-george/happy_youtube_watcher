namespace :daily_snapshot_job do
  desc 'Run the daily snapshot for hardcoded playlist'
  task :run => :environment do
    PlaylistSnapshot.create_snapshot!
  end
end
