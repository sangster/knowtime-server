@routes.each do |route|
  (@route_trips[route.id] || []).keep_if { |trip| trip.is_running? @minutes }
  @route_trips.delete_if { |_, trips| trips.empty? }
end
@routes.keep_if { |route| @route_trips.has_key? route.id }

json.array! @routes do |route|
  json.routeId route.route_id
  json.shortName route.short_name
  json.longName route.long_name

  json.tripHeadsigns do
    json.partial! partial: 'v1/trips/start_and_end_stops', collection: @route_trips[route.id], as: :trip
  end
end
