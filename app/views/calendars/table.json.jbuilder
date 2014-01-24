json.array! @tables.keys do |headsign|
  table = @tables[headsign]

  json.headsign headsign

  json.stops do
    json.array! table.stop_numbers
  end

  json.trips do
    json.array! table do |arrival_time|
        json.array! arrival_time
    end
  end
end
