json.location do
  json.lat user_location.lat
  json.lng user_location.lng
end

json.time user_location.created_at.strftime('%T')