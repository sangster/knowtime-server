class StopTime < ActiveRecord::Base
  MERGED_STOP_ID = /\d+_merged_(\d+)/

  default_scope { order arrival_time: :asc, stop_sequence: :asc }

  belongs_to :trip, inverse_of: :stop_times, shared_key: :trip_id
  belongs_to :stop, inverse_of: :stop_time, shared_key: :stop_id

  alias_attribute :arrival, :arrival_time
  alias_attribute :departure, :departure_time
  alias_attribute :index, :stop_sequence
  alias_attribute :stop_number, :stop_id

  class << self
    def new_from_csv(row)
      merged = MERGED_STOP_ID.match row[:stop_id]
      row[:stop_id] = merged[1] if merged

      new        stop_id: row[:stop_id],
                 trip_id: row[:trip_id],
           stop_sequence: row[:stop_sequence],
            arrival_time: to_minutes(row[:arrival_time]),
          departure_time: to_minutes(row[:departure_time])
    end

    # Return the StopTimes that are coming up next for buses on the given bus
    # line. Will only return the first StopTime found for a individual stop, and
    # only the first StopTime for an individual trip.
    def next_stops(short_name, time, duration = nil)
      minutes = (time.seconds_since_midnight / 60).to_i

      #Rails.cache.fetch("next_stops_#{short_name}_#{minutes}_#{duration}", expires_in: 2.minute) do
        trips = Trip.day_trips short_name, time

        stop_times =
          if duration
            range = (minutes..(minutes + duration/60))
            StopTime.where departure_time: range
          else
            StopTime.where 'departure_time >= ?', minutes
          end


        tids = trips.distinct.pluck :trip_id
        trips = trips.where trip_id: stop_times.where(trip_id: tids).pluck(:trip_id)

        stops = trips.collect do |trip|
          trip.stop_times.select do |st|
            if duration
              range === st.departure
            else
              st.departure >= minutes
            end
          end
        end.flatten.sort_by! &:arrival

        stops = select_first_match(stops) { |s| s.trip_id }
        select_first_match(stops) { |s| s.stop_id }
      #end
    end

    private

    def to_minutes(str)
      str[0, 2].to_i * 60 + str[3, 2].to_i
    end

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
