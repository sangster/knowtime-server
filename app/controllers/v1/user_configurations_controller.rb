class V1::UserConfigurationsController < V1::ApplicationController
  include Rakeable

  def pollrate
    @pollrate = 6
  end

  def check_remote_zip
    return render text: 'bad admin uuid', status: :unauthorized unless correct_admin_uuid?

    if DataPull.remote_zip_new?
      call_rake :update_from_remote_zip
      render text: 'updating data from metro transit'
    else
      render text: 'current data is up-to-date'
    end
  end
end
