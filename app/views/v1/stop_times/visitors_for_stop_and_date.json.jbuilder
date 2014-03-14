json.array! @visitors do |visitor|
  route = visitor.route

  json.routeId route.route_id
  json.shortName route.short_name
  json.longName route.long_name
  json.stopTimes do
    json.array! visitor.stop_times do |st|
      json.arrival st.arrival
      json.departure st.departure
    end
  end
end