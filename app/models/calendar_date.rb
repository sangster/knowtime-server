class CalendarDate < ActiveRecord::Base
  belongs_to :calendar, foreign_key: :service_id

  class << self
    def new_from_csv(row)
      new service_id: row[:service_id],
          date: to_date(row[:date]),
          exception_type: row[:exception_type]
    end

    private

    def to_date(str)
      Time.zone.parse str
    end
  end

  def added?
    exception_type == 1
  end

  def removed?
    !added?
  end
end
