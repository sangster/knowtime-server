class Trip
  include Mongoid::Document

  field :_id, type: String
  field :h, as: :headsign, type: String

  belongs_to :calendar
  belongs_to :path

  embeds_one :route
  embeds_many :stop_times, inverse_of: :trip


  def self.new_from_csv(row)
    {_id: row[:trip_id], headsign: row[:trip_headsign],
     route: Route.find(row[:route_id]), calendar_id: row[:service_id], path_id: row[:shape_id]}
  end

  def self.for_uuid(uuid_str)
    key = Uuid.key_for uuid_str
    Trip.find key unless key.nil?
  end

  def self.get(str)
    Rails.cache.fetch("trip_#{str}") { Uuid.get(Trip.uuid_namespace, str).idable }
  end

  #alias_method :uncached_stop_times, :stop_times
  #
  #def stop_times
  #  Rails.cache.fetch("trip_#{id}_stop_times", expires_in: 1.hour) { uncached_stop_times }
  #end

  def is_running?(time)
    minutes = case time
                when Date
                  time.hour * 60 + time.minute
                else
                  time.to_i
              end

    stops = stop_times.asc :index
    (stops.first.arrival..stops.last.departure) === minutes
  end

  def uuid
    Uuid.for self
  end
end
