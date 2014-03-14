class BusEstimation
  include Distanceable
  attr_accessor :stop_number, :arrival, :lat, :lng

  class << self
    def active_lines(opts = {})
      opts.reverse_merge! time: nil, duration: 10.seconds
      users =
        if opts[:time]
          time_end = opts[:time]
          time_start = time_end - opts[:duration]
          User.with_locations_between (time_start..time_end)
        else
          User.recent opts[:duration]
        end

      users.distinct.pluck :route_short_name
    end

    def locations_and_next_stops(short_name, time, opts = {})
      opts.reverse_merge! duration: nil, bounds: nil

      next_stops = StopTime.next_stops short_name, time, opts[:duration]

      users = User.where route_short_name: short_name
      groups = UserGroup.create_groups users, bounds: opts[:bounds]

      map_estimates groups, next_stops
    end

    private

    def map_estimates(groups, next_stops)
      return [] if next_stops.empty?

      estimates = []
      options = next_stops

      groups.select(&:location).each do |group|
        group_loc = group.location

        closest_index = 0
        closest_dist = Distanceable::EARTH_DIAMETER

        options.each_index do |i|
          stop_loc = options[i].stop.location
          dist = stop_loc.distance_from group_loc
          if dist < closest_dist
            closest_index = i
            closest_dist = dist
          end
        end

        opt = options.delete_at closest_index
        estimates << BusEstimation.new(opt.stop_number, opt.arrival, group_loc.lat, group_loc.lng)
      end

      options.each do |opt|
        estimates << BusEstimation.new(opt.stop_number, opt.arrival, 0, 0)
      end

      stop_numbers_seen = []
      estimates.each do |est|
        stop_number = est.stop_number

        if stop_numbers_seen.include? stop_number
          estimates.delete est
        else
          stop_numbers_seen << stop_number
        end
      end

      estimates.tap {|e| e.uniq! &:stop_number }
    end
  end


  def initialize(stop_number, arrival, lat, lng)
    self.stop_number = stop_number
    self.arrival = arrival
    self.lat = lat
    self.lng = lng
  end

  def arrival_str
    minutes_to_time arrival
  end


  private


  def minutes_to_time(minutes)
    '%02d:%02d' % [minutes/60, minutes%60]
  end
end
