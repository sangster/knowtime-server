json.location do
  json.lat est.lat
  json.lng est.lng
end

json.nextStopNumber est.stop_number
json.estimateArrival est.arrival_str