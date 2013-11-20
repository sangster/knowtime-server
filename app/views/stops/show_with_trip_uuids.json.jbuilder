json.partial! 'public', stop: @stop

json.trips do
  json.array! @stop.trips, partial: 'trips/uuids_only', as: :trip
end
