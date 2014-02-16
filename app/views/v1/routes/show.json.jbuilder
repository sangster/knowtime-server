json.partial! 'public', route: @route

json.trips do
  json.array! @route.trips do |trip|
    json.tripId trip.uuid
    json.tripHeadsign trip.headsign
    json.routeId trip.route.uuid
    json.calendarId trip.calendar.uuid
    json.pathId trip.path.uuid
  end
  #json.partial! partial: 'trips/uuids_only', collection: @route.trips, as: :trip
end