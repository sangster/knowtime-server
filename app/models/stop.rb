require 'ostruct'

class Stop
  include Mongoid::Document

  field :_id, type: Integer
  field :n, as: :name, type: String
  field :t, as: :lat, type: Float
  field :g, as: :lng, type: Float

  TO_LOWER = %w(Bvld Dr Ave Rd St To Pk Terr Ct Pkwy Hwy Lane Way Entrance Entr)
  MERGED_STOP_ID = /\d+_merged_(\d+)/

  alias_method :stop_number, :id

  class << self
    def from_gtfs(row)
      id = row.id
      merged = MERGED_STOP_ID.match id
      id = merged[1] if merged

      create! _id: id,
        name: format_stop_name( row.name ),
        lat: row.lat,
        lng: row.lon
    end

    def get(stop_number)
      Rails.cache.fetch("stop_#{stop_number}", expire_in: 1.day) do
        Stop.find stop_number
      end
    end

    def all_by_stop_number
      Rails.cache.fetch("all_stops", expire_in: 1.day) do
        all.sort_by &:stop_number
      end
    end

    private

    def format_stop_name(str)
      str.strip!
      TO_LOWER.each { |lower| str.gsub! /\b#{lower}\b/, lower.downcase }
      str[0] = str[0].upcase
      str
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
    @_location ||= Location.new lat, lng, nil
  end

  def location=(loc)
    self.lat = loc.lat
    self.lng = loc.lng
    @_location = nil
  end

  private

  def trips_criteria
    Trip.where(:'stop_times.n' => self.stop_number)
  end

  def uncached_find_visitors(calendars)
    trips = trips_criteria.where(:calendar_id.in => calendars.to_a).to_a

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
