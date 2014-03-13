class Calendar
  include Mongoid::Document

  embeds_many :calendar_exceptions
  has_many :trips

  scope :not_ferry, -> { where id: /^((?!fer).)*$/ }

  class << self
    def new_from_csv(row)
      {service_id: row[:service_id],
       start_date: to_date(row[:start_date]),
         end_date: to_date(row[:end_date]),
           monday: to_bool(row[:monday]),
          tuesday: to_bool(row[:monday]),
        wednesday: to_bool(row[:monday]),
         thursday: to_bool(row[:monday]),
           friday: to_bool(row[:monday]),
         saturday: to_bool(row[:saturday]),
           sunday: to_bool(row[:sunday])}
     end

     def for_date_params(params)
      for_date Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    end

    def for_date(date)
      criteria = Calendar.not_ferry.where(:start_date.lte => date).where(:end_date.gte => date)
      if date.saturday?
        criteria.where saturday: true
      elsif date.sunday?
        criteria.where sunday: true
      else
        criteria.where weekday: true
      end.to_a
    end

    def for_uuid(uuid_str)
      key = Uuid.key_for uuid_str
      Calendar.find key unless key.nil?
    end

    private

    def to_date(str)
      Time.zone.parse str
    end

    def to_bool(str)
      str == '1'
    end
  end

  def uuid
    Uuid.for self
  end

  def weekday
    monday or tuesday or wednesday or thursday or friday
  end

  def ferry?
    id.include? 'fer'
  end

  def trip_groups(short_name)
    Rails.cache.fetch "#{id}_#{short_name}" do
      groups = Trip.where( calendar: self ).where( 'route.s' => short_name).group_by &:headsign

      groups.each_key do |headsign|
        groups[headsign] = groups[headsign].sort {|a,b| a.stop_times.first <=> b.stop_times.first }
      end
    end
  end
end
