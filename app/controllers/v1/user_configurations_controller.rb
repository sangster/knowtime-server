class V1::UserConfigurationsController < V1::ApplicationController
  include Rakeable

  def pollrate
    @pollrate = 6
  end
end
