class Route < ActiveRecord::Base
  has_one :uuid, as: :idable
  has_many :trips, inverse_of: :route


  def self.new_from_csv(row)
    route = Route.new short_name: row[:route_short_name], long_name: row[:route_long_name]
    route.build_uuid uuid: Uuid.create(uuid_namespace, row[:route_id]).raw
    route
  end

  def self.uuid_namespace
    Uuid.create_namespace 'Routes'
  end

  def self.for_uuid(uuid_str)
    Uuid.find_idable 'Route', uuid_str
  end

  def self.names
    Rails.cache.fetch("route_names", expire_in: 24.hours) { uncached_names }
  end

  def self.uncached_names
    names = Route.uniq.pluck(:short_name, :long_name).collect do |names|
      OpenStruct.new short_name: names[0], long_name: names[1]
    end

    sort_by_names! names
  end

  def self.sort_by_names!(arr)
    get_short_name = block_given? ? lambda { |o| yield o } : lambda(&:short_name)

    arr.sort! do |o1, o2|
      s1 = get_short_name.call o1
      s2 = get_short_name.call o2

      if is_int? s1
        (is_int? s2) ? s1.to_i <=> s2.to_i : -1
      elsif is_int? s2
        1
      else
        s1 <=> s2
      end
    end
  end

  def self.is_int?(str)
    true if Integer(str) rescue false
  end

  private_class_method :uncached_names, :'is_int?'


  def self.for_short_name_and_calendars short_name, calendars
    Rails.cache.fetch("routes_#{short_name}_#{calendars.collect(&:id).join ','}", expires_in: 6.hours) do
      sort_by_names! uniq.joins(:trips).where('trips.calendar_id' => calendars, short_name: short_name)
    end
  end

  def self.simple_query(key, val)
    routes = case key
               when 'short'
                 where short_name: val
               when 'long'
                 where long_name: val
               when 'stop'
                 stop = Stop.get val.to_i
                 uniq.joins(:trips, 'JOIN stop_times on trip_id = trips.id').where 'stop_times.stop_id = ?', stop.id
               when 'date'
                 calendars = Calendar.for_date Date.parse(val)
                 uniq.joins(:trips).where 'trips.calendar_id' => calendars
               else
                 raise ActiveRecord::RecordNotFound
             end

    sort_by_names! routes
  end

  def self.short_name_exists?(short_name)
    Rails.cache.fetch("short_name_exists_#{short_name}", expires_in: 1.hour) do
      Route.exists? short_name: short_name
    end
  end

end
