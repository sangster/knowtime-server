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

	def initialize(lat, lng, created_at = DateTime.now)
		self.lat = lat
		self.lng = lng
		self.created_at = created_at
	end

	def ==(o)
		lat == o.lat and lng == o.lng and created_at == o.created_at
	end
end