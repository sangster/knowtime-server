json.array! @next_stops do |st|
	json.stopNumber st.stop_number
	if st.arrival_str != st.departure_str
		json.arrival st.arrival_str
		json.departure st.departure_str
	else
		json.time st.arrival_str
	end
end
