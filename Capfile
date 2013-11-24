namespace :deploy do
  task :check_remote_zip, :roles => :app do
    unless ENV['DISABLE_INITIALIZER_FROM_RAKE']
      Rails.cache.clear
      DataPull.check_remote_zip
    end
  end
end

after 'deploy', 'deploy:restart_daemons'