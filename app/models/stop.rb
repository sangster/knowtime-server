require 'ostruct'

class Stop < ActiveRecord::Base
  has_many :stop_times

  TO_LOWER = %w(Bvld Dr Ave Rd St To Pk Terr Ct Pkwy Hwy Lane Way Entrance Entr.)


  def self.new_from_csv(row)
    Stop.new stop_number: row[:stop_id], name: format_short_name(row[:stop_name]), lat: row[:stop_lat], lng: row[:stop_lon]
  end

  def self.format_short_name(str)
    str.strip!
    TO_LOWER.each { |lower| str.gsub! /\b#{lower}\b/, lower.downcase }
    str[0] = str[0].upcase
    str
  end

  def self.get(stop_number)
    Rails.cache.fetch("stop_#{stop_number}", expire_in: 1.day) do
      Stop.find_by_stop_number stop_number
    end
  end

  def self.get_id(stop_number)
    get(stop_number).id
  end

  def find_visitors(calendars)
    Rails.cache.fetch("stop_#{id}_visitors_#{calendars.collect(&:id).join ','}", expires_in: 1.hour) do
      uncached_find_visitors calendars
    end
  end

  def route_short_names
    Rails.cache.fetch("route_short_names_#{id}") do
      query = Route.joins :trips, 'JOIN stop_times on trip_id = trips.id'
      query = query.where('stop_times.stop_id = ?', id).uniq.pluck :short_name

      Route.sort_by_names!(query.to_a) { |e| e }
    end
  end

  def trips
    Rails.cache.fetch("stop_#{id}_trips", expires_in: 1.hour) do
      Trip.uniq.joins(:stop_times).where('stop_times.stop_id = ?', id).to_a
    end
  end

  def location
    @_location ||= Location.new lat, lng
  end

  def location= loc
    self.lat = loc.lat
    self.lng = loc.lng
  end


  private


  def uncached_find_visitors(calendars)
    trips = Trip.joins('JOIN stop_times on trip_id = trips.id') \
      .where(calendar_id: calendars).where('stop_id = ?', id).order 'arrival'

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
