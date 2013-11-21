json.tripId Uuid.from_trip_id trip.id
json.headsign trip.headsign

startTime = trip.stop_times.order(:index).first
json.start startTime.arrival_str
json.startStop { json.partial! 'stops/public', stop: startTime.stop }

endTime = trip.stop_times.order(:index).last
json.end endTime.departure_str
json.endStop { json.partial! 'stops/public', stop: endTime.stop }