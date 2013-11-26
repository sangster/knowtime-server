class StopTime < ActiveRecord::Base
  belongs_to :stop, inverse_of: :stop_times
  belongs_to :trip


  def self.new_from_csv(row)
    trip_id = Uuid.get_id Trip.uuid_namespace, row[:trip_id]
    stop_id = Stop.get_id row[:stop_id].to_i

    StopTime.new trip_id: trip_id, stop_id: stop_id, index: row[:stop_sequence],
                 arrival: to_minutes(row[:arrival_time]), departure: to_minutes(row[:departure_time])
  end

  def self.for_stop_and_trips(stop, trips)
    where(stop_id: stop, trip_id: trips).order :arrival
  end

  def self.to_minutes(str)
    str[0, 2].to_i * 60 + str[3, 2].to_i
  end

  def self.next_stops(short_name, time, duration = nil)
    Rails.cache.fetch("next_stops_#{short_name}_#{time.strftime '%F_%R'}_#{duration}", expires_in: 2.minutes) do
      minutes = time.hour * 60 + time.minute
      st = StopTime.uniq.joins(:trip, trip: :route).includes(:stop)
      st.order(:arrival)
      st = st.where('short_name = ?', short_name).where 'trips.calendar_id' => Calendar.for_date(time)
      if duration
        st.where departure: (minutes..(minutes + duration/60))
      else
        st.where 'departure >= ?', minutes
      end
      st.to_a
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
    "%02d:%02d" % [minutes/60, minutes%60]
  end
end
