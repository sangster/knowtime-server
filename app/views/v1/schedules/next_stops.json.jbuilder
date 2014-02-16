json.array! @next_stops do |st|
  json.stopNumber st.stop.id
  json.arrival st.arrival_str
  json.departure st.departure_str
end
