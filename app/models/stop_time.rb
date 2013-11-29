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


  def self.new_from_csv(row)
    tr = trip row[:trip_id]
    tr << StopTime.new(stop_number: row[:stop_id].to_i, index: row[:stop_sequence],
                       arrival: to_minutes(row[:arrival_time]), departure: to_minutes(row[:departure_time]))
  end

  def self.for_stop_and_trips(stop, trips)
    where(stop_number: stop.stop_number).where(:trip.in => trips).asc(:arrival).to_a

    stop_number = stop.stop_number
    trips.collect do |t|
      t.stop_times.select { |st| st.stop_number == stop_number }
    end.flatten.sort_by! &:arrival
  end

  def self.to_minutes(str)
    str[0, 2].to_i * 60 + str[3, 2].to_i
  end

  @@_tr = []
  @@_id = nil

  def self.trip(trip_id)
    if @@_id.nil? or @@_id != trip_id
      unless @@_tr.empty?
        t = Trip.find(@@_id)
        t.stop_times = @@_tr
        t.save!
      end
      @@_tr.clear
      @@_id = trip_id
    end
    @@_tr
  end

  def self.skip_bulk_insert?
    true
  end

  def self.skip_final_bulk_insert?
    unless @@_tr.empty?
      t = Trip.find(@@_id)
      t.stop_times = @@_tr
      t.save!
    end
    @@_tr = nil
    @@_id = nil
    true
  end


  def self.next_stops(short_name, time, duration = nil)
    minutes = time.hour * 60 + time.minute

    Rails.cache.fetch("next_stops_#{short_name}_#{minutes}_#{duration}", expires_in: 1.minute) do
      trips = Trip.day_trips(short_name, time)

      if duration
        range = (minutes..(minutes + duration/60)) if duration
        trips.where(:'stop_times.d' => range)
      else
        trips.where(:'stop_times.d'.gte => minutes)
      end

      trips.collect do |t|
        t.stop_times.select do |st|
          if duration
            range === st.departure
          else
            st.departure >= minutes
          end
        end
      end.flatten.sort_by! &:arrival
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
