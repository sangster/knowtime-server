class LocationBounds

  attr_accessor :lat_range, :lng_range


  def self.each(step=1)
    return enum_for(:each, step) unless block_given?

    Location.each(step).each do |loc_1|
      Location.each(step).each do |loc_2|
        yield LocationBounds.new(loc_1, loc_2)
      end
    end
  end

  def initialize(loc_1, loc_2)
    lats = [loc_1.lat, loc_2.lat]
    lngs = [loc_1.lng, loc_2.lng]

    self.lat_range = lats.min..lats.max
    self.lng_range = lngs.min..lngs.max
  end

  def ===(loc)
    cover? loc
  end

  def cover?(loc)
    self.lat_range.cover? loc.lat and self.lng_range.cover? loc.lng
  end
end