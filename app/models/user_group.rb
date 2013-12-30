class UserGroup
  include Distanceable
  attr_accessor :users

  GROUP_RADIUS = 40 # metres


  def self.create_groups(users, opts={})
    opts.reverse_merge! bounds: nil, radius: GROUP_RADIUS

    active_users = users.select do |u|
      false if opts[:bounds].present? and not u.within? opts[:bounds]
      u.moving? and u.active?
    end

    groups = []
    active_users.each do |user|
      closest = user.closest_group groups, opts[:radius]
      (closest || UserGroup.new.tap{|g| groups << g}) << user
    end
    groups
  end

  def initialize
    self.users = []
    @_location = nil
  end

  def <<(user)
    self.users << user
    @_location = nil
    self
  end

  def count
    users.length
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