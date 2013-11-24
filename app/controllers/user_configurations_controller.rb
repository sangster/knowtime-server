class UserConfigurationsController < ApplicationController
  include Rakeable

  def pollrate
    @pollrate = 3
  end

  def check_remote_zip
    if DataPull.remote_zip_new?
      call_rake :update_from_remote_zip
      render text: 'updating data from metro transit'
    else
      render text: 'current data is up-to-date'
    end
  end
end
