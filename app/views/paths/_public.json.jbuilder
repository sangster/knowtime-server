json.pathId Uuid.from_path_id path.id

json.pathPoints do
  json.array! path.path_points do |location|
    json.lat location.lat
    json.lng location.lng
  end
end
