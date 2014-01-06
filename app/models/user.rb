require 'uuidtools'
require 'ostruct'

class User
  include Mongoid::Document

  field :s, as: :short_name, type: String
  field :u, as: :uuid, type: BSON::Binary
  field :m, as: :moving_flag, type: Boolean, default: false

  scope :recent, ->(age) { elem_match( user_locations: { :created_at.gt => (Time.zone.now - age) } ) }

  embeds_many :user_locations, inverse_of: :user

  IS_MOVING_DELTA = 10 # metres
  AVERAGE_OLDER_WEIGHT = 0.25


  def self.get(user_uuid_str)
    uuid = BSON::Binary.new UUIDTools::UUID.parse(user_uuid_str).raw, :uuid
    where(uuid: uuid).first rescue nil
  end

  def self.recent_users_bus_map(age)
    User.recent( age ).inject( {} ) do |map,user|
      (map[user.short_name] ||= []) << user unless user.user_locations.empty?
      map
    end
  end

  def uuid_str
    @_uuid_str ||= UUIDTools::UUID.parse_raw(uuid.data).to_s
  end

  def moving?
    @_moving ||= (moving_flag or check_is_moving IS_MOVING_DELTA)
  end

  def newest_location
    @_newest_location ||= user_locations.last
  end

  def active?
    newest_location.created_at > (Time.zone.now - 10.seconds) rescue false
  end

  def within?(bounds)
    bounds.cover? newest_location if newest_location
  end

  def closest_group(groups, radius)
    closest = nil
    closest_distance = Distanceable::EARTH_DIAMETER

    groups.select(&:location).each do |group|
      dist = newest_location.distance_from group.location
      if dist < closest_distance and dist < radius
        closest = group
        closest_distance = dist
      end
    end

    closest
  end


  private


  def check_is_moving(delta)
    return false if user_locations.length < 2

    first = user_locations.first
    moving = user_locations[1..-1].any? { |loc| loc.distance_from(first) > delta }

    if moving
      self.moving_flag = true
      save
    end

    moving
  end
end
