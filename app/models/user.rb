require 'uuidtools'
require 'ostruct'

class User
  include Mongoid::Document

  field :s, as: :short_name, type: String
  field :u, as: :uuid, type: BSON::Binary
  field :m, as: :moving, type: Boolean, default: false

  scope :recent, ->(age) { elem_match( user_locations: { :created_at.gt => (DateTime.now - age) } ) }

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
    @_uuid_str ||= UUIDTools::UUID.parse_raw(uuid.data).to_s
  end

  def moving?
    @_moving ||= (super or check_is_moving)
  end

  def newest_location
    @_newest_location ||= user_locations.last
  end

  def active?
    newest_location.created_at > (DateTime.now - 10.seconds) rescue false
  end


  private


  def check_is_moving
    locs = self.user_locations
    return false if locs.length < 2

    first = locs.first
    moving = locs[1..-1].any? { |loc| loc.distance_from(first) > IS_MOVING_DELTA }

    if moving
      self.moving = true
      self.save
    end
    moving
  end
end
