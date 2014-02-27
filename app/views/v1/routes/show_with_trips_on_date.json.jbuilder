json.partial! 'public', route: @route

json.trips do
  json.partial! partial: 'v1/trips/uuids_only', collection: @route.trips.where(calendar_id: @calendars), as: :trip
end
