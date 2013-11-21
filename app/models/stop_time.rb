class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip


  def self.new_from_csv row
    trip_id = Uuid.get_id Trip.uuid_namespace, row[:trip_id]
    stop_id = Stop.get_id row[:stop_id].to_i

    StopTime.new trip_id: trip_id, stop_id: stop_id, index: row[:stop_sequence],
                 arrival: to_minutes(row[:arrival_time]), departure: to_minutes(row[:departure_time])
  end


  def self.for_stop_and_trips stop, trips
    where(stop_id: stop, trip_id: trips).order :arrival
  end


  def self.to_minutes str
    str[0, 2].to_i * 60 + str[3, 2].to_i
  end


  def arrival_str
    minutes_to_time arrival
  end


  def departure_str
    minutes_to_time departure
  end


  private


  def minutes_to_time minutes
    "%02d:%02d" % [minutes/60, minutes%60]
  end
end
