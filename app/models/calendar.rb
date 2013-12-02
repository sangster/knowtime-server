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

  def self.new_from_csv(row)
    {_id: row[:service_id],
     start_date: to_date(row[:start_date]),
     end_date: to_date(row[:end_date]),
     weekday: to_bool(row[:monday]),
     saturday: to_bool(row[:saturday]),
     sunday: to_bool(row[:sunday])}
   end

   def self.to_date(str)
    Date.strptime str, '%Y%m%d'
  end

  def self.to_bool(str)
    return str == '1'
  end

  def self.for_date_params(params)
    for_date Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  end

  def self.for_date(date)
    criteria = Calendar.where(:start_date.lte => date).where(:end_date.gte => date)
    if date.saturday?
      criteria = criteria.where saturday: true
    elsif date.sunday?
      criteria = criteria.where sunday: true
    else
      criteria = criteria.where weekday: true
    end
  end

  def self.for_uuid(uuid_str)
    key = Uuid.key_for uuid_str
    Calendar.find key unless key.nil?
  end

  def uuid
    Uuid.for self
  end
end
