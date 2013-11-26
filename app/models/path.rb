class Path < ActiveRecord::Base
  has_one :uuid, as: :idable
  has_many :path_points, inverse_of: :path
  has_many :trips, inverse_of: :path

  alias_method :uncached_path_points, :path_points


  def self.uuid_namespace
    Uuid.create_namespace 'Paths'
  end


  def self.for_uuid uuid_str
    Uuid.find_idable 'Path', uuid_str
  end


  def self.for_route_and_calendars(route, calendars)
    Rails.cache.fetch("path_for_route_#{route.id}_calendar_#{calendars.collect(&:id).join ','}", expires_in: 1.hour) do
      Trip.where(route_id: route.id, calendar_id: calendars).collect(&:path).uniq
    end
  end


  def path_points
    Rails.cache.fetch("path_points_#{id}") { uncached_path_points.to_a }
  end
end
