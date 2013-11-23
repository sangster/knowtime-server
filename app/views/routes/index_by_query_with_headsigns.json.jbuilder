@routes.delete_if { |route| @route_trips[route.id].empty? }

json.array! @routes do |route|
  json.partial! 'public', route: route
  json.tripHeadsigns do
    json.partial! partial: 'trips/start_and_end_stops', collection: @route_trips[route.id], as: :trip
  end
end