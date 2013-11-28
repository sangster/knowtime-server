json.tripId trip.uuid
json.headsign trip.headsign

startTime = trip.stop_times.asc(:index).first
json.start startTime.arrival_str
json.startStop { json.partial! 'stops/public', stop: startTime.stop }

endTime = trip.stop_times.asc(:index).last
json.end endTime.departure_str
json.endStop { json.partial! 'stops/public', stop: endTime.stop }