class Route
  include Mongoid::Document

  field :_id, type: String
  field :s, as: :short_name, type: String
  field :l, as: :long_name, type: String

  index short_name: 1


  def self.from_gtfs(row)
    create! _id: row.id,
      short_name: row.short_name,
      long_name: row.long_name
  end

  def self.for_uuid(uuid_str)
    key = Uuid.key_for uuid_str
    Route.find key unless key.nil? rescue nil
  end

  def self.names
    Rails.cache.fetch('route_names', expire_in: 6.hour) { uncached_names }
  end

  def self.uncached_names
    names = Route.all.pluck(:short_name, :long_name).uniq.collect do |names|
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
      trips = Trip.where('route.s' => short_name).where(:calendar.in => calendars)
      sort_by_names! trips.distinct(:route).collect { |r| Route.new r }
    end
  end

  def self.simple_query(key, val)
    routes = case key
               when 'short'
                 where short_name: val
               when 'long'
                 where long_name: val
               when 'stop'
                 Trip.where('stop_times.n' => val.to_i ).distinct(:route).collect {|r| Route.new r}.uniq
               when 'date'
                 calendars = Calendar.for_date Time.zone.parse(val)
                 Trip.where(:calendar.in => calendars).distinct(:route).collect { |r| Route.new r }.uniq
               else
                 []
             end

    sort_by_names! routes
  end

  def self.short_name_exists?(short_name)
    Route.where(short_name: short_name).exists?
  end

  def uuid
    Uuid.for self
  end

  def trips
      Trip.where('route._id' => id)
  end
end
