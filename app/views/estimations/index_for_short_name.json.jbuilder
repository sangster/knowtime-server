json.array! @estimations do |est|
  json.location do
    json.lat est.lat
    json.lng est.lng
  end

  json.nextStopNumber est.next_stop.stop_number
  json.estimateArrival est.arrival_str
end