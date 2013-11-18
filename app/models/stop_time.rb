class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip

  def self.new_from_csv row
    trip_id = Uuid.get_id Trip.uuid_namespace, row[:trip_id]
    stop_id = Stop.get_id row[:stop_id].to_i

    StopTime.new trip_id: trip_id, stop_id: stop_id, index: row[:stop_sequence],
                 arrival: to_minutes(row[:arrival_time]), departure: to_minutes(row[:departure_time])
  end


  def self.to_minutes str
    str[0, 2].to_i * 60 + str[3, 2].to_i
  end
end
