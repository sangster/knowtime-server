class V1::StopTimesController < V1::ApplicationController
  def visitors_for_stop_and_date
    calendars = Calendar.for_date_params params
    @visitors = Stop.get(params[:stop_number].to_i).find_visitors calendars
  end
end
