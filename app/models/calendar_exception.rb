class CalendarException < ActiveRecord::Base
  belongs_to :calendar


  def self.new_from_csv row
    calendar_id = Uuid.get_id Calendar.uuid_namespace, row[:service_id]
    CalendarException.new calendar_id: calendar_id, date: to_date(row[:date])
  end


  def self.to_date str
    Date.strptime str, '%Y%m%d'
  end
end
