class Calendar < ActiveRecord::Base
  has_one :uuid, as: :idable, :autosave => true, :dependent => :destroy
  has_many :trips, inverse_of: :calendar

  def self.new_from_csv row
    cal = Calendar.new start_date: to_date(row[:start_date]), end_date: to_date(row[:end_date]),
                       monday: to_bool(row[:monday]), tuesday: to_bool(row[:tuesday]), wednesday: to_bool(row[:wednesday]),
                       thursday: to_bool(row[:thursday]), friday: to_bool(row[:friday]), saturday: to_bool(row[:saturday]),
                       sunday: to_bool(row[:sunday])
    cal.build_uuid uuid: Uuid.create(uuid_namespace, row[:service_id]).raw
    cal
  end


  def self.for_date_params params
    for_date Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  end


  def self.for_date date
    Rails.cache.fetch("calendars_for_date_#{date.to_s}", expires_in: 12.hour) do
      Calendar.where("? BETWEEN start_date AND end_date AND #{date.strftime('%A').downcase} = TRUE", date).to_a
    end
  end


  def self.uuid_namespace
    Uuid.create_namespace 'Calendars'
  end

  def self.to_date str
    Date.strptime str, '%Y%m%d'
  end


  def self.to_bool str
    return str == '1'
  end


  def self.for_uuid uuid_str
    Uuid.find_idable 'Calendar', uuid_str
  end
end
