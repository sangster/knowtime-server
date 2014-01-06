class Calendar
  include Mongoid::Document

  field :_id, type: String
  field :s, as: :start_date, type: Date
  field :e, as: :end_date, type: Date
  field :w, as: :weekday, type: Boolean
  field :a, as: :saturday, type: Boolean
  field :u, as: :sunday, type: Boolean

  index start_date: 1
  index end_dat: 1
  index weekday: 1
  index saturday: 1
  index sunday: 1

  embeds_many :calendar_exceptions
  has_many :trips

  class << self
    def new_from_csv(row)
      {       _id: row[:service_id],
       start_date: to_date(row[:start_date]),
         end_date: to_date(row[:end_date]),
          weekday: to_bool(row[:monday]),
         saturday: to_bool(row[:saturday]),
           sunday: to_bool(row[:sunday]) }
     end

     def for_date_params(params)
      for_date Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    end

    def for_date(date)
      criteria = Calendar.where(:start_date.lte => date).where(:end_date.gte => date)
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
      return str == '1'
    end
  end

  def uuid
    Uuid.for self
  end
end
