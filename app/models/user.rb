require 'uuidtools'
require 'ostruct'

class User < ActiveRecord::Base
  has_many :user_locations, inverse_of: :user

  scope :newest_locations, -> { where 'created_at > ?', (DateTime.now - RECENT_ENTRIES_TIME) }

  IS_MOVING_DELTA = 10 # metres
  AVERAGE_OLDER_WEIGHT = 0.25
  RECENT_ENTRIES_TIME = 30.seconds


  def self.get user_uuid_str
    Rails.cache.fetch("user_#{user_uuid_str}", expires_in: 10.minutes) do
      find_by uuid: UUIDTools::UUID.parse(user_uuid_str).raw
    end
  end

  def uuid_str
    @_uuid_str ||= UUIDTools::UUID.parse_raw uuid
  end

  def is_moving?
    locs = self.newest_locations
    return false if locs.length < 2

    first = locs.first
    first_distant_location = locs[1..-1].find { |loc| loc.distance_from(first) > IS_MOVING_DELTA }

    not first_distant_location.nil?
  end

  def average_location
    @_average_location ||= calculate_average_location
  end

  private

  def calculate_average_location
    if self.newest_locations.empty?
      nil
    else
      first = self.newest_locations.first
      lat = first.lat
      lng = first.lng

      self.newest_locations[1..-1].each do |loc|
        lat = lat + AVERAGE_OLDER_WEIGHT * (loc.lat - lat)
        lng = lng + AVERAGE_OLDER_WEIGHT * (loc.lng - lng)
      end

      OpenStruct.new created_at: first.created_at, lat: lat, lng: lng
    end
  end
end
