class V2::BusLine
  attr_accessor :short_name, :long_name, :calendar_id, :path_id


  class << self
    def all
      lines = {}

      Calendar.not_ferry.each do |cal|
        cal.trips.each do |trip|
          line = (lines[trip.route.short_name] ||= create trip, cal)

        end
      end

      Route.sort_by_names! lines.values
    end

    private

    def create(trip, cal)
      new.tap do |b|
        b.short_name = trip.route.short_name
        b.long_name = trip.route.long_name
        b.calendar_id = cal.id
        b.path_id = trip.path.id
      end
    end
  end
end
