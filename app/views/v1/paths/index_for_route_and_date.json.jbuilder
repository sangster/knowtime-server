json.array! @paths do |path|
	json.pathId path.to_a.first.shape_id

	json.pathPoints do
		json.array! path do |location|
			json.lat location.lat
			json.lng location.lng
		end
	end
end
