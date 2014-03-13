json.tripId trip.trip_id
json.headsign trip.headsign

startTime = trip.stop_times.first
json.start startTime.arrival_str
json.startStop { json.partial! 'v1/stops/public', stop: startTime.stop }

endTime = trip.stop_times.last
json.end endTime.departure_str
json.endStop { json.partial! 'v1/stops/public', stop: endTime.stop }
