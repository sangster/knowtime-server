json.ignore_nil! true

json.status 'success'
json.data do
  json.set! controller_name do
    json.array!(@records) do |record|
      json.extract! record,
        *%i{id code name desc lat lon zone_id location_type parent_station
               stop_timezone wheelchair_boarding}
    end
  end
end
