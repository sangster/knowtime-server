class StopTime
  include Mongoid::Document

  field :n, as: :stop_number, type: Integer
  field :i, as: :index, type: Integer
  field :a, as: :arrival, type: Integer
  field :d, as: :departure, type: Integer

  index stop_number: 1
  index arrival: 1
  index departure: 1

  embedded_in :trip, inverse_of: :stop_times
  belongs_to :stop, inverse_of: :stop_times, foreign_key: :n, index: true

  class << self
    @@_unsaved_times = []
    @@_id = nil

    def new_from_csv(row)
      tr = unsaved_stop_times row[:trip_id]
      tr << StopTime.new(stop_number: row[:stop_id].to_i, index: row[:stop_sequence],
       arrival: to_minutes(row[:arrival_time]), departure: to_minutes(row[:departure_time]))
    end

    def for_stop_and_trips(stop, trips)
      stop_number = stop.stop_number
      trips.collect do |t|
        t.stop_times.select { |st| st.stop_number == stop_number }
      end.flatten.sort_by! &:arrival
    end

    def skip_bulk_insert?
      true
    end

    def skip_final_bulk_insert?
      unless @@_unsaved_times.empty?
        t = Trip.find(@@_id)
        t.stop_times = @@_unsaved_times
        t.save!
      end
      @@_unsaved_times = []
      @@_id = nil
      true
    end

    # Return the StopTimes that are coming up next for buses on the given bus
    # line. Will only return the first StopTime found for a invidual stop, and
    # only the first StopTime for an individual trip.
    def next_stops(short_name, time, duration = nil)
      minutes = (time.seconds_since_midnight / 60).to_i

      Rails.cache.fetch("next_stops_#{short_name}_#{minutes}_#{duration}", expires_in: 2.minute) do
        trips = Trip.day_trips(short_name, time)

        if duration
          range = (minutes..(minutes + duration/60))
          trips.where(:'stop_times.d' => range)
        else
          trips.where(:'stop_times.d'.gte => minutes)
        end

        stops = trips.collect do |trip|
          trip.stop_times.select do |st|
            if duration
              range === st.departure
            else
              st.departure >= minutes
            end
          end
        end.flatten.sort_by! &:arrival

        stops = select_first_match(stops) { |s| s.trip.id     }
        stops = select_first_match(stops) { |s| s.stop_number }
      end
    end

    private


    def select_first_match(stop_times, &block)
      seen = Set.new

      stop_times.select do |stop|
        key = block.call stop
        if seen.include? key
          false
        else
          seen << key
        end
      end
    end

    def to_minutes(str)
      str[0, 2].to_i * 60 + str[3, 2].to_i
    end

    def unsaved_stop_times(trip_id)
      if @@_id.nil? or @@_id != trip_id
        unless @@_unsaved_times.empty?
          t = Trip.find(@@_id)
          t.stop_times = @@_unsaved_times
          t.save!
        end
        @@_unsaved_times.clear
        @@_id = trip_id
      end
      @@_unsaved_times
    end
  end

  def arrival_str
    minutes_to_time arrival
  end

  def departure_str
    minutes_to_time departure
  end

  private

  def minutes_to_time(minutes)
    '%02d:%02d' % [minutes/60, minutes%60]
  end
end
