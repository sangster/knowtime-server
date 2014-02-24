json.array! @calendars do |cal|
	json.calendarId cal.id
	json.start cal.start_date
	json.end cal.end_date
	json.days do
	  json.partial! 'days', calendar: cal
  end
end
