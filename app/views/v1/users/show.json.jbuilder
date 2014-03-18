json.array! @user_locations do |user_location|
	json.location do
		json.lat user_location.lat
		json.lng user_location.lon
	end
	json.time user_location.created_at.strftime('%T')
end
