json.partial! 'public', route: @route

json.trips do
  json.partial! partial: 'trips/uuids_only', collection: @route.trips, as: :trip
end