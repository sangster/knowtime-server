json.partial! 'public', stop: @stop

json.trips do
  json.array! @stop.trips do |trip|
    json.tripId trip.uuid
    json.tripHeadsign trip.headsign
    json.routeId trip.route.uuid
    json.calendarId trip.calendar.uuid
    json.pathId trip.path.uuid
  end
  #json.trips { json.array! @stop.trips, partial: 'trips/uuids_only', as: :trip }
end

