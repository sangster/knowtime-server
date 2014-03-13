class Trip < ActiveRecord::Base
  scope :bus_line, ->(block_id) { where block_id: block_id }

  scope :day_trips, ->(short_name, time) do
    rids = Route.where(route_short_name: short_name).distinct.pluck :route_id
    sids = Calendar.for_date(time).distinct.pluck :service_id
    puts "\n\n\n\nsids: #{sids}\n\n\n"
    where(route_id: rids).where(service_id: sids)
  end

  belongs_to :route, inverse_of: :trips, shared_key: :route_id
  belongs_to :calendar, shared_key: :service_id
  has_many :shapes, inverse_of: :trip, shared_key: :shape_id
  has_many :stop_times, inverse_of: :trip, shared_key: :trip_id
  #,
  #    order: 'arrival_time ASC'

  has_many :stops, through: :stop_times

  #default_scope includes(:stop_times)

  alias_attribute :headsign, :trip_headsign

  class << self
    def new_from_csv(row)
      new       trip_id: row[:trip_id],
               block_id: row[:block_id],
          trip_headsign: row[:trip_headsign],
               route_id: row[:route_id],
             service_id: row[:service_id],
               shape_id: row[:shape_id]
    end
  end


  def is_running?(time)
    minutes =
      case time
      when Date, Time
        time.hour * 60 + time.minute
      else
        time.to_i
      end

    stops = stop_times
    (stops.first.arrival..stops.last.departure) === minutes
  end
end
