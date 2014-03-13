class Calendar < ActiveRecord::Base
  scope :not_ferry, -> { where %q{service_id NOT LIKE '%fer%'} }
  scope :weekday, -> { where('NOT (saturday OR sunday)') }
  scope :weekend, -> { where('saturday OR sunday') }
  scope :date_is, ->(date) do
    where('start_date <= :date AND end_date >= :date', date: date)
  end
  scope :for_date, ->(date) do
    if date.saturday?
      where saturday: true
    elsif date.sunday?
      where sunday: true
    else
      weekday
    end.not_ferry.date_is date
  end

  has_many :calendar_dates, inverse_of: :calendar, shared_key: :service_id
  has_many :trips, inverse_of: :calendar, shared_key: :service_id

  has_many :routes, through: :trips
  has_many :shapes, through: :trips

  class << self
    def new_from_csv(row)
      new service_id: row[:service_id],
          start_date: to_date(row[:start_date]),
            end_date: to_date(row[:end_date]),
              monday: to_bool(row[:monday]),
             tuesday: to_bool(row[:monday]),
           wednesday: to_bool(row[:monday]),
            thursday: to_bool(row[:monday]),
              friday: to_bool(row[:monday]),
            saturday: to_bool(row[:saturday]),
              sunday: to_bool(row[:sunday])
    end

    def for_date_params(params)
      for_date Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    end

    private

    def to_date(str)
      Time.zone.parse str
    end

    def to_bool(str)
      str == '1'
    end
  end

  def weekday
    monday or tuesday or wednesday or thursday or friday
  end

  def ferry?
    service_id.include? 'fer'
  end
end
