json.array! @bus_riders_map.keys do |short_name|
	json.shortName short_name
	json.users do
		json.array! @bus_riders_map[short_name] do |user|
			json.uuid user.uuid
			json.isMoving user.moving?

			json.latestLocation do 
				last_loc = user.user_locations.last
				json.time last_loc.created_at.strftime '%T'
				json.lat last_loc.lat
				json.lng last_loc.lon
			end
		end
	end
end