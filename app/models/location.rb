class Location
  include Distanceable

  attr_accessor :lat, :lng, :created_at

  def self.each(step=1)
    return enum_for(:each, step) unless block_given?

    (-90..90).step(step).each do |lat|
      (-180..180).step(step).each do |lng|
        yield Location.new(lat, lng)
      end
    end
  end

  def initialize(lat, lng, created_at = Time.zone.now)
    self.lat = lat
    self.lng = lng
    self.created_at = created_at
  end

  def ==(o)
    if created_at or o.created_at
      return false unless created_at.to_i == o.created_at.to_i
    end
    lat == o.lat && lng == o.lng
  rescue
    false # one of the times was nil
  end
end