json.partial! 'public', stop: @stop

json.trips { json.array! @stop.trips, partial: 'trips/uuids_only', as: :trip }
