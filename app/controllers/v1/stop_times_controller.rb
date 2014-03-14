class V1::StopTimesController < V1::ApplicationController
  def visitors_for_stop_and_date
    calendars = Calendar.for_date_params params
    @visitors = Stop.find_by(stop_id: params[:stop_id]).find_visitors calendars
  end
end
