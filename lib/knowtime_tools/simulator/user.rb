require 'rest_client'
require 'json'

module Knowtime
  module Simulator
    class User
      def initialize(base_url, short_name)
        @base, @short_name = base_url, short_name
        @user_url = get_user_url
      end

      def post_location(lat, lng)
        @locations = nil
        json = {lat: lat, lng: lng}.to_json
        RestClient.post @user_url, json, content_type: :json, accept: :json
      end

      def locations
        @locations ||= fetch_locations
      end

      def id
        @id ||= @user_url.split('/')[-1] if @user_url
      end

      private

      def get_user_url
        response = RestClient.post new_user_url, nil
        response.headers[:location]
      end

      def new_user_url
        "#{@base}/alpha_1/users/new/#{@short_name}"
      end

      def fetch_locations
        result = RestClient.get @user_url
        json = JSON.parse result.to_s, object_class: OpenStruct
      end
    end
  end
end