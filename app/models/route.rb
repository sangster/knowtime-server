class Route < ActiveRecord::Base
  has_one :uuid, as: :idable
  has_many :trips, inverse_of: :route


  def self.new_from_csv row
    route = Route.new short_name: row[:route_short_name], long_name: row[:route_long_name]
    route.build_uuid uuid: Uuid.create(uuid_namespace, row[:route_id]).to_s
    route
  end


  def self.uuid_namespace
    Uuid.create_namespace 'Routes'
  end


  def self.names
    Rails.cache.fetch("route_names", expire_in: 24.hours) { uncached_names }
  end


  def self.uncached_names
    names = Route.uniq.pluck(:short_name, :long_name).collect do |names|
      OpenStruct.new short_name: names[0], long_name: names[1]
    end

    names.sort! do |name_1, name_2|
      s1 = name_1.short_name
      s2 = name_2.short_name

      if is_int? s1
        (is_int? s2) ? s1.to_i <=> s2.to_i : -1
      elsif is_int? s2
        1
      else
        s1 <=> s2
      end
    end
  end


  def self.is_int? str
    true if Integer(str) rescue false
  end


  private_class_method :uncached_names, :'is_int?'


  def self.for_short_name_and_calendars short_name, calendars
    Rails.cache.fetch("routes_#{short_name}_#{calendars.collect(&:id).join ','}", expires_in: 6.hours) do
      uniq.joins(:trips).where('trips.calendar_id' => calendars, short_name: short_name).to_a
    end
  end
end
