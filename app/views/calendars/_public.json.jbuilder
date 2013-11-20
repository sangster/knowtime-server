json.calendarId Uuid.from_calendar_id calendar.id
json.start calendar.start_date
json.end calendar.end_date
json.days do
  json.partial! 'days', calendar: calendar
end
