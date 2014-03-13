namespace :knowtime do
  desc "Download GTFS from '#{METRO_TRANSIT['zip_url']}'"
  task update: :environment do
    Rails.cache.clear
    DataPull.update_from_remote_zip
  end
end