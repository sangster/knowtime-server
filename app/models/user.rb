class User < ActiveRecord::Base
  IS_MOVING_DELTA = 10 # metres
  AVERAGE_OLDER_WEIGHT = 0.25
  ACTIVE_WINDOW = 10.seconds

  default_scope { includes :user_locations }
  scope :recent, ->(age) { where 'updated_at >= ?', (Time.zone.now - age) }
  scope :with_locations_between, ->(range) { where updated_at: range }

  has_many :user_locations, inverse_of: :user

  alias_attribute :short_name, :route_short_name

  class << self
    def recent_users_bus_map(age)
      recent( age ).inject( {} ) do |map, user|
        unless user.user_locations.empty?
          (map[user.short_name] ||= []) << user
        end
        map
      end
    end
  end

  def moving?
    @_moving ||= (moving_flag or check_is_moving IS_MOVING_DELTA)
  end

  def newest_location
    @_newest_location ||= user_locations.last
  end

  def active?
    newest_location.created_at > (Time.zone.now - ACTIVE_WINDOW) rescue false
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
