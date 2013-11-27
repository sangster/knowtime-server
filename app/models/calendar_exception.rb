class CalendarException
  include Mongoid::Document

  #belongs_to :calendar

  field :_id, type: String
  field :d, as: :date, type: Date

  embedded_in :calendar

  def self.new_from_csv(row)
    Calendar.find(row[:service_id]).calendar_exceptions.create!(date: to_date(row[:date]))
  end

  def self.to_date(str)
    Date.strptime str, '%Y%m%d'
  end

  def self.skip_bulk_insert?
    true
  end

  def self.skip_final_bulk_insert?
    true
  end
end
