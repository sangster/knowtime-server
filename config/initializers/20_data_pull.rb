unless ENV['DISABLE_INITIALIZER_FROM_RAKE']
  Rails.cache.clear
  DataPull.check_remote_zip
end
