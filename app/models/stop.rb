require 'ostruct'

class Stop
  include Mongoid::Document

  field :_id, type: Integer
  field :n, as: :name, type: String
  field :t, as: :lat, type: Float
  field :g, as: :lng, type: Float

  #has_many :stop_times, inverse_of: :stops, foreign_key: 'stop_number'

  TO_LOWER = %w(Bvld Dr Ave Rd St To Pk Terr Ct Pkwy Hwy Lane Way Entrance Entr.)

  alias_method :stop_number, :id

  def self.new_from_csv(row)
    {_id: row[:stop_id],
     name: format_short_name(row[:stop_name]),
     lat: row[:stop_lat],
     lng: row[:stop_lon]}
  end

  def self.format_short_name(str)
    str.strip!
    TO_LOWER.each { |lower| str.gsub! /\b#{lower}\b/, lower.downcase }
    str[0] = str[0].upcase
    str
  end

  def self.get(stop_number)
    Rails.cache.fetch("stop_#{stop_number}", expire_in: 1.day) do
      Stop.find stop_number
    end
  end

  def find_visitors(calendars)
    Rails.cache.fetch("stop_#{id}_visitors_#{calendars.collect(&:id).join ','}", expires_in: 1.hour) do
      uncached_find_visitors calendars
    end
  end

  def route_short_names
    Rails.cache.fetch("route_short_names_#{id}") do
      Route.sort_by_names!(trips_criteria.only('route.s').collect { |t| t.route.short_name }.uniq) { |e| e }
    end
  end

  def trips
    Rails.cache.fetch("stop_#{id}_trips", expires_in: 1.hour) do
      trips_criteria.to_a
    end
  end

  def location
    @_location ||= Location.new lat, lng
  end

  def location=(loc)
    self.lat = loc.lat
    self.lng = loc.lng
  end

  private

  def trips_criteria
    Trip.where(:'stop_times.n' => self.stop_number)
  end

  def uncached_find_visitors(calendars)
    trips = trips_criteria.where(:calendar_id.in => calendars).to_a

    routes_with_visitors = {}
    StopTime.for_stop_and_trips(self, trips).collect do |st|
      route = st.trip.route
      struct = routes_with_visitors[route.id] ||= OpenStruct.new(route: st.trip.route, stop_times: [])
      struct.stop_times << OpenStruct.new(arrival: st.arrival_str, departure: st.departure_str)
    end

    routes_with_visitors.values.each { |visitor| visitor.stop_times.uniq! }
    routes_with_visitors.values
  end
end
