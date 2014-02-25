class CalendarException
  include Mongoid::Document

  #belongs_to :calendar

  field :_id, type: String
  field :d, as: :date, type: Date

  embedded_in :calendar

  class << self
    def from_gtfs(row)
      cal = Calendar.find row.service_id
      cal.calendar_exceptions.create! date: to_date( row.date )
    end

    def skip_bulk_insert?
      true
    end

    def skip_final_bulk_insert?
      true
    end

    private

    def to_date(str)
      Time.zone.parse str
    end
  end
end
