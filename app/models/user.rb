require 'uuidtools'
require 'ostruct'

class User < ActiveRecord::Base
  has_many :user_locations, inverse_of: :user

  IS_MOVING_DELTA = 10 # metres
  AVERAGE_OLDER_WEIGHT = 0.25

  def self.get user_uuid_str
    Rails.cache.fetch("user_#{user_uuid_str}", expires_in: 10.minutes) do
      find_by uuid: UUIDTools::UUID.parse(user_uuid_str).raw
    end
  end


  def uuid_str
    @_uuid_str ||= UUIDTools::UUID.parse_raw uuid
  end


  def is_moving?
    locs = user_locations
    return false if locs.length < 2

    first = locs.first
    locs[1..-1].find(false) { |loc| loc.distance_from(first) > IS_MOVING_DELTA }
  end


  def average_location
    @_average_location ||= calculate_average_location
  end


  private


  def calculate_average_location
    if user_locations.empty?
      nil
    else
      first = user_locations.first
      lat = first.lat
      lng = first.lng

      user_locations[1..-1].each do |loc|
        lat = lat + AVERAGE_OLDER_WEIGHT * (loc.lat - lat)
        lng = lng + AVERAGE_OLDER_WEIGHT * (loc.lng - lng)
      end

      OpenStruct.new created_at: first.created_at, lat: lat, lng: lng
    end
  end
end
