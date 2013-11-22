json.array! @routes do |route|
  json.partial! 'public', route: route
  json.tripHeadsigns do
    @route_trips[route.id].each do |trip|
      startTime = trip.stop_times.order(:index).first
      endTime = trip.stop_times.order(:index).last

      if @minutes >= startTime.arrival and @minutes <= endTime.departure
        json.partial! 'trips/start_and_end_stops', trip: trip
      end
    end
  end
end