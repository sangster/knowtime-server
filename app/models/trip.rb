class Trip
  include Mongoid::Document

  field :_id, type: String
  field :h, as: :headsign, type: String

  #belongs_to :route
  belongs_to :calendar
  belongs_to :path

  embeds_one :route
  has_many :stop_times

  #has_one :uuid, as: :idable
  #has_many :stop_times, inverse_of: :trip
  #belongs_to :route, inverse_of: :trips
  #belongs_to :calendar, inverse_of: :trips
  #belongs_to :path, inverse_of: :trips
  #has_many :stops, through: :stop_times


  def self.new_from_csv(row)
    {_id: row[:trip_id], headsign: row[:trip_headsign],
     route: Route.find(row[:route_id]), calendar_id: row[:service_id], path_id: row[:shape_id]}
  end

  def self.for_uuid(uuid_str)
    Uuid.find_idable 'Trip', uuid_str
  end

  # Ferries do not have paths, so create a blank one
  def self.get_path_id(row)
    if row[:shape_id].nil?
      Path.create.id
    else
      uuid_id = Uuid.get_id Path.uuid_namespace,
                            uuid_id.nil? ? Path.create.id : uuid_id
    end
  end

  def self.uuid_namespace
    Uuid.create_namespace 'Trips'
  end

  def self.get(str)
    Rails.cache.fetch("trip_#{str}") { Uuid.get(Trip.uuid_namespace, str).idable }
  end

  def route_uuid
    Uuid.from_route_id route_id
  end

  def calendar_uuid
    Uuid.from_calendar_id calendar_id
  end

  def path_uuid
    Uuid.from_path_id path_id
  end

  alias_method :uncached_stop_times, :stop_times

  def stop_times
    Rails.cache.fetch("trip_#{id}_stop_times", expires_in: 1.hour) { uncached_stop_times }
  end

  def is_running?(time)
    minutes = case time
                when Integer
                  time
                when Date
                  time.hour * 60 + time.minute
              end

    stops = stop_times.order :index
    (stops.first.arrival..stops.last.departure) === minutes
  end
end
