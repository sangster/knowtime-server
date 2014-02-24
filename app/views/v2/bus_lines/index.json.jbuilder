json.array! @bus_lines do |line|
  json.shortName line.short_name
  json.longName line.long_name
  json.calendarId line.calendar_id
  json.pathId line.path_id
end
