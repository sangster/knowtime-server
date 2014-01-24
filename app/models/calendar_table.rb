class CalendarTable
  include Enumerable
  attr_accessor :name, :trips

  def initialize(name, trips)
    self.name = name
    self.trips = trips
  end

  def stop_numbers
    @stop_numbers ||= self.trips.inject([]) do |list,trip|
      trip.stop_numbers.length > list.length ? trip.stop_numbers : list
    end
  end

  def length
    self.trips.length
  end

  def each &block  
    self.trips.each do |trip|
      times = arrival_times trip
      if block_given?
        block.call times
      else  
        yield times
      end
    end  
  end

  def [](i)
    arrival_times self.trips[i]
  end

  private

  def arrival_times(trip)
    times = trip.stop_times.to_a

    if times.length == stop_numbers.length
      return times.collect &:arrival_str
    end

    stop_numbers.collect do |num|
      times.find {|t| t.stop_number == num }.arrival_str rescue nil
    end
  end
end
