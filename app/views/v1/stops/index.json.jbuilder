json.array! @stops do |stop|
	json.stopNumber stop.stop_id.to_i
	json.name stop.name

	json.location do
		json.lat stop.lat
		json.lng stop.lng
	end
end
