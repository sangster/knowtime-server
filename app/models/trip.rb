class Trip
  include Mongoid::Document

  field :_id, type: String
  field :h, as: :headsign, type: String

  belongs_to :calendar
  belongs_to :path

  embeds_one :route
  embeds_many :stop_times, inverse_of: :trip

  scope :route_day_trips, ->(short_name, time) do
    where('route.s' => short_name).where(:calendar.in => Calendar.for_date(time).to_a)
  end

  class << self
    def new_from_csv(row)
      {        _id: row[:trip_id],
          headsign: row[:trip_headsign],
             route: Route.find(row[:route_id]),
       calendar_id: row[:service_id],
           path_id: row[:shape_id] }
    end

    def for_uuid(uuid_str)
      key = Uuid.key_for uuid_str
      Trip.find key unless key.nil?
    end

    def get(str)
      Rails.cache.fetch "trip_#{str}", expires_in: 6.hours do
        Uuid.get(Trip.uuid_namespace, str).idable
      end
    end

    def day_trips(short_name, time)
      Rails.cache.fetch "day_trips_#{short_name}_#{time.strftime '%F_%R'}", expires_in: 1.hour do
        Trip.route_day_trips short_name, time
      end
    end
  end

  def is_running?(time)
    minutes = case time
                when Date, Time
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

  def stop_numbers
    stop_times.collect &:stop_number
  end
end
