class Location
  include Distanceable

  attr_accessor :lat, :lng

  def initialize lat, lng
    self.lat = lat
    self.lng = lng
  end
end