class Path < ActiveRecord::Base
  has_one :uuid, as: :idable
  has_many :path_points, inverse_of: :path
  has_many :trips, inverse_of: :path

  alias_method :uncached_path_points, :path_points


  def self.uuid_namespace
    Uuid.create_namespace 'Paths'
  end


  def self.for_route_and_calendars route, calendars
    Path.joins(:trips, :calendars).where route: route, calendar: calendars
  end


  def path_points
    Rails.cache.fetch("path_points_#{id}") { uncached_path_points.to_a }
  end
end
