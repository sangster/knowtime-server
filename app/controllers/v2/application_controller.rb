class V2::ApplicationController < ActionController::Base

  after_filter :cors_set_access_control_headers


  protected


  def render_error status, message = nil
    status = convert_status status
    message = default_message status if message.nil?
    render text: "{\"status\":\"#{status}\",\"error\":\"#{message.to_s}\"}", status: status
  end

  def time_params?
    params.key? :time or params.key? :date
  end

  def time_from_params
    begin
      Time.zone.parse( params[:time] || params[:date] ).tap do |time|
        logger.info "Using user-provided '#{time}' instead of current time"
      end
    rescue
      nil
    end or Time.zone.now
  end

  private

  def convert_status status
    case status
      when 404, :not_found
        404
      else
        599
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


  private

  
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
    headers['Access-Control-Max-Age'] = "1728000"
  end
end

