task environment: :disable_initializer

task :update_from_remote_zip do
  Rails.cache.clear
  DataPull.update_from_remote_zip
end