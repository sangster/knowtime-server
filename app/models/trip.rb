class Trip < ActiveRecord::Base
  has_one :uuid, as: :idable
  belongs_to :route
  belongs_to :calendar
  belongs_to :path


  def self.new_from_csv row
    route_id = Uuid.get_id Route.uuid_namespace, row[:route_id]
    calendar_id = Uuid.get_id Calendar.uuid_namespace, row[:service_id]

    trip = Trip.new headsign: row[:trip_headsign], route_id: route_id, calendar_id: calendar_id, path: get_path(row)
    trip.build_uuid uuid: Uuid.create(uuid_namespace, row[:trip_id]).to_s
    trip
  end


  # Ferries do not have paths, so create a blank one
  def self.get_path row
    if row[:shape_id].nil?
      Path.create
    else
      uuid = Uuid.get Path.uuid_namespace, row[:shape_id]
      unless uuid.nil?
        uuid.idable
      else
        Path.create
      end
    end
  end


  def self.uuid_namespace
    Uuid.create_namespace 'Trips'
  end


  def self.get str
    Rails.cache.fetch("trip_#{str}") { Uuid.get(Trip.uuid_namespace, str).idable }
  end
end
