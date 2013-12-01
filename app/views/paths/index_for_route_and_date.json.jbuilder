json.array! @paths do |path|
	json.pathId path.uuid

	json.pathPoints do
		json.array! path.path_points do |location|
			json.lat location.lat
			json.lng location.lng
		end
	end
end
# json.partial! partial: 'public', collection: @paths, as: :path