# This file is part of the KNOWtime server.
#
# The KNOWtime server is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# The KNOWtime server is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with the KNOWtime server.  If not, see <http://www.gnu.org/licenses/>.
#
# See http://labs.omniti.com/labs/jsend
module JsendResponses
  extend ActiveSupport::Concern

  def jsend_fail(data:, http_status: :bad_request)
    fail = JsendFail.new data: data

    respond_to do |format|
      format.json { render json: fail, status: http_status }
    end
  end

  def jsend_error(message:, code: nil, data: nil,
                  http_status: :internal_server_error)
    error = JsendError.new message: message, code: code, data: data

    respond_to do |format|
      format.json { render json: error, status: http_status }
    end
  end

  class JsendFail
    attr_accessor :data

    def initialize(data:)
      raise ArgumentError, 'data' if data.nil?
      self.data = data
    end

    def to_json
      "{'status':'fail','data':#{data.to_json}}"
    end
  end


  class JsendError
    attr_accessor :message, :code, :data

    def initialize(message:, code: nil, data: nil)
      raise ArgumentError, 'message' if message.nil?
      self.message = message
      self.code = code
      self.data = data
    end

    def to_json
      "{'status':'error','data':#{message.to_json}#{append_code}#{append_data}}"
    end

    private

    def append_code
      code.nil? ? '' : ",'code':#{code.to_json}"
    end

    def append_data
      data.nil? ? '' : ",'data':#{data.to_json}"
    end
  end
end
