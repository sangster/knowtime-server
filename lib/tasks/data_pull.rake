task update_from_remote_zip: :environment do
  Rails.cache.clear
  DataPull.update_from_remote_zip
end