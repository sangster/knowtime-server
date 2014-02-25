json.array! @user_locations do |user_location|
	json.location do
		json.lat user_location.lat
		json.lng user_location.lng
	end
	json.time user_location.created_at.strftime('%T')
end
#json.partial! partial: 'user_location', collection: @user_locations, as: :user_location