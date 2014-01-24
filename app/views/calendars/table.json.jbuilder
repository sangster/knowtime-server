json.array! @groups.keys do |headsign|
  json.headsign headsign

  json.stops do
    json.array! @groups[headsign].first.stop_numbers
  end

  json.trips do
    json.array! @groups[headsign] do |trip|
        json.array! trip.stop_times.collect &:arrival_str
    end
  end
end
