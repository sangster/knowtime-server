json.array! @schedules.keys do |headsign|
  schedule = @schedules[headsign]

  json.headsign headsign

  json.stops do
    json.array! schedule.stop_numbers
  end

  json.trips do
    json.array! schedule do |arrival_time|
        json.array! arrival_time
    end
  end
end
