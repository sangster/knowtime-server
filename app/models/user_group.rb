class UserGroup
  include Distanceable
  attr_accessor :users

  GROUP_RADIUS = 40 # metres

  def self.create_groups(users)
    groups = []
    users.select(&:is_moving?).each do |user|
      group = closest_group(groups, user) || (groups << UserGroup.new and groups.last)
      group.add user
    end
    groups
  end

  def self.closest_group(groups, user)
    user_location = user.average_location
    closest = nil
    closest_distance = Distanceable::EARTH_DIAMETER

    groups.each do |group|
      dist = user_location.distance_from group.average_location
      if dist < closest_distance and dist < GROUP_RADIUS
        closest = group
        closest_distance = dist
      end
    end

    closest
  end

  def initialize
    self.users = []
    @average_location = nil
  end

  def add(user)
    self.users << user
    @average_location = nil
  end

  def average_location
    @average_location ||= calculate_average_location
  end

  def lat
    average_location.lat rescue 0.0
  end

  def lng
    average_location.lng rescue 0.0
  end

  private


  def calculate_average_location
    lat_sum = 0
    lng_sum = 0

    active_users = self.users.select &:average_location
    return nil if active_users.empty?

    active_users.each do |user|
      loc = user.average_location
      lat_sum = lat_sum + loc.lat
      lng_sum = lng_sum + loc.lng
    end

    Location.new lat_sum/active_users.length, lng_sum/active_users.length
  end
end