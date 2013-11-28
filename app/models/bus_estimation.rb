class BusEstimation
  include Distanceable
  attr_accessor :stop_number, :arrival, :lat, :lng

  def initialize(stop_number, arrival, lat, lng)
    self.stop_number = stop_number
    self.arrival = arrival
    self.lat = lat
    self.lng = lng
  end


  def arrival_str
    minutes_to_time arrival
  end


  private


  def minutes_to_time(minutes)
    '%02d:%02d' % [minutes/60, minutes%60]
  end
end