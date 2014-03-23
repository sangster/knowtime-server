json.stopNumber stop.stop_number.to_i
json.name stop.name

json.location do
  json.lat stop.lat
  json.lng stop.lng
end