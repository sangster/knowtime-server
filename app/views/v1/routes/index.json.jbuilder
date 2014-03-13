json.array! @routes do |route|
  json.routeId route.route_id
  json.shortName route.short_name
  json.longName route.long_name
end