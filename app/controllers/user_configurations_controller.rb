class UserConfigurationsController < ApplicationController
  def pollrate
    @pollrate = 3
  end

  def check_remote_zip
    unless ENV['DISABLE_INITIALIZER_FROM_RAKE']
      Rails.cache.clear
      DataPull.check_remote_zip
    end
    render text: 'OK'
  end
end
