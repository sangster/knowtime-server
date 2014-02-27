json.tripId trip.uuid
json.headsign trip.headsign

startTime = trip.stop_times.asc(:index).first
json.start startTime.arrival_str
json.startStop { json.partial! 'v1/stops/public', stop: startTime.stop }

endTime = trip.stop_times.asc(:index).last
json.end endTime.departure_str
json.endStop { json.partial! 'v1/stops/public', stop: endTime.stop }
