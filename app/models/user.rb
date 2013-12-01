require 'uuidtools'
require 'ostruct'

class User
  include Mongoid::Document

  field :s, as: :short_name, type: String
  field :u, as: :uuid, type: BSON::Binary

  scope :recent, -> (age) { elem_match( :user_locations => { :created_at.gt => (DateTime.now - age) } ) }

  embeds_many :user_locations, inverse_of: :user

  IS_MOVING_DELTA = 10 # metres
  AVERAGE_OLDER_WEIGHT = 0.25


  def self.get(user_uuid_str)
    uuid = BSON::Binary.new UUIDTools::UUID.parse(user_uuid_str).raw, :uuid

    #Rails.cache.fetch("user_#{user_uuid_str}", expires_in: 10.minutes) do
    where(uuid: uuid).first rescue nil
    #end
  end

  def self.recent_users_bus_map(age)
    User.recent(age).inject({}) do |map,user|
      (map[user.short_name] ||= []) << user unless user.user_locations.empty?
      map
    end
  end

  def uuid_str
    @_uuid_str ||= UUIDTools::UUID.parse_raw uuid.data
  end

  def is_moving?
    locs = self.user_locations.newest
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
    newest_locations = self.user_locations.newest

    if newest_locations.empty?
      nil
    else
      first = newest_locations.first
      lat = first.lat
      lng = first.lng

      newest_locations[1..-1].each do |loc|
        lat = lat + AVERAGE_OLDER_WEIGHT * (loc.lat - lat)
        lng = lng + AVERAGE_OLDER_WEIGHT * (loc.lng - lng)
      end

      Location.new lat, lng, first.created_at
    end
  end
end
