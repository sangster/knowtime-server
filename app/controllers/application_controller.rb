class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  protected

  def render_error status, message = nil
    status = convert_status status
    message = default_message status if message.nil?
    render text: "{\"status\":\"#{status}\",\"error\":\"#{message.to_s}\"}", status: status
  end

  private

  def convert_status status
    case status
      when 404, :not_found
        '404'
      else
        '599'
    end
  end

  def default_message status
    case status
      when 404, :not_found
        'not found'
      else
        'could not complete request'
    end
  end

  def correct_admin_uuid?
    params[:admin_uuid] == SECRETS['knowtime']['admin_uuid']
  end
end
