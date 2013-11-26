class Location
  include Distanceable

  attr_accessor :lat, :lng, :created_at

  def initialize(lat, lng, created_at = DateTime.now)
    self.lat = lat
    self.lng = lng
    self.created_at = created_at
  end
end