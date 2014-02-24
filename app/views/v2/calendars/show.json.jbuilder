json.calendarId @calendar.id
json.start @calendar.start_date
json.end @calendar.end_date
json.days do
  json.partial! 'days', calendar: @calendar
end
