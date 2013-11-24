class BusEstimation
  include Distanceable
  attr_accessor :next_stop, :arrival, :lat, :lng

  def initialize(next_stop, arrival, lat, lng)
    self.next_stop = next_stop
    self.arrival = arrival
    self.lat = lat
    self.lng = lng
  end


  def arrival_str
    minutes_to_time arrival
  end


  private


  def minutes_to_time minutes
    "%02d:%02d" % [minutes/60, minutes%60]
  end
end