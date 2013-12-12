class UserGroup
  include Distanceable
  attr_accessor :users

  GROUP_RADIUS = 40 # metres

  def self.create_groups(users)
    groups = []
    users.select(&:moving?).each do |user|
      group = closest_group(groups, user) || (groups << UserGroup.new and groups.last)
      group << user
    end
    groups
  end

  def self.closest_group(groups, user)
    user_location = user.newest_location
    closest = nil
    closest_distance = Distanceable::EARTH_DIAMETER

    groups.each do |group|
      dist = user_location.distance_from group.newest_location
      if dist < closest_distance and dist < GROUP_RADIUS
        closest = group
        closest_distance = dist
      end
    end

    closest
  end

  def initialize
    self.users = []
    @_location = nil
  end

  def <<(user)
    self.users << user
    @_location = nil
  end

  def location
    @_location ||= calculate_location
  end

  def lat
    location.lat rescue Float::NAN
  end

  def lng
    location.lng rescue Float::NAN
  end

  private


  def calculate_location
    lat_sum = 0
    lng_sum = 0

    active_users = users.select &:active?
    return nil if active_users.empty?

    active_users.each do |user|
      loc = user.newest_location
      lat_sum = lat_sum + loc.lat
      lng_sum = lng_sum + loc.lng
    end

    Location.new lat_sum/active_users.length, lng_sum/active_users.length
  end
end