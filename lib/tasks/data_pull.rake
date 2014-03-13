namespace :knowtime do
  task update: :environment do
    Rails.cache.clear
    DataPull.update_from_remote_zip
  end
end