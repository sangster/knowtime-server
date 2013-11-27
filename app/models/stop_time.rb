class StopTime
  include Mongoid::Document

  field :n, as: :stop_number, type: Integer
  field :i, as: :index, type: Integer
  field :a, as: :arrival, type: Integer
  field :d, as: :departure, type: Integer

  index stop_number: 1
  index arrival: 1
  index departure: 1

  #belongs_to :stop, inverse_of: :stop_times
  belongs_to :trip, index: true


  def self.new_from_csv(row)
    {trip_id: row[:trip_id], stop_number: row[:stop_id].to_i, index: row[:stop_sequence],
     arrival: to_minutes(row[:arrival_time]), departure: to_minutes(row[:departure_time])}
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
