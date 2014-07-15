json.ignore_nil! true

json.status 'success'
json.data do
  json.set! 'data_sets' do
    json.array! @data_sets do |data_set|
      json.extract! data_set, *%i(id name title)
      json.last_updated data_set.last_updated

      json.min do
        json.lat data_set.min_lat
        json.lon data_set.min_lon
      end
      json.max do
        json.lat data_set.max_lat
        json.lon data_set.max_lon
      end

      unless data_set.start_date.nil? || data_set.end_date.nil?
        json.dates do
          json.start data_set.start_date
          json.end data_set.end_date
        end
      end
    end
  end
end
