class Stop < ActiveRecord::Base
  MERGED_STOP_ID = /\d+_merged_(\d+)/
  TO_LOWER = %w(Bvld Dr Ave Rd St To Pk Terr Ct Pkwy Hwy Lane Way Entrance Entr)

  has_many :stop_time, inverse_of: :stop, shared_key: :stop_id

  alias_attribute :stop_number, :stop_id
  alias_attribute :name, :stop_name
  alias_attribute :lat, :stop_lat
  alias_attribute :lng, :stop_lon

  class << self
    def new_from_csv(row)
      merged = MERGED_STOP_ID.match row[:stop_id]
      row[:stop_id] = merged[1] if merged

      new stop_id: row[:stop_id],
          stop_name: format_name( row[:stop_name] ),
          stop_lat: row[:stop_lat],
          stop_lon: row[:stop_lon]
    end

    private

    def format_name(str)
      str.strip!
      TO_LOWER.each { |lower| str.gsub! /\b#{lower}\b/, lower.downcase }
      str[0] = str[0].upcase
      str
    end
  end

  def find_visitors(calendars)
    sids = calendars.collect &:service_id
    tids = Trip.where( service_id: sids ).pluck :trip_id
    tids = StopTime.where( stop_id: stop_id, trip_id: tids ).pluck :trip_id
    trips = Trip.find_by trip_id: tids

    routes_with_visitors = {}
    StopTime.where(stop_id: stop_id, trip_id: tids ).collect do |st|
      route = st.trip.route
      struct = routes_with_visitors[route.id] ||= OpenStruct.new(route: st.trip.route, stop_times: [])
      struct.stop_times << OpenStruct.new(arrival: st.arrival_str, departure: st.departure_str)
    end

    routes_with_visitors.values.each { |visitor| visitor.stop_times.uniq! }
    routes_with_visitors.values
  end

  def location
    @_location ||= Location.new lat, lng, nil
  end
end
