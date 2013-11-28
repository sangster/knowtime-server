class Path
  include Mongoid::Document

  field :_id, type: String
  embeds_many :path_points, inverse_of: :path

  #has_one :uuid, as: :idable
  #has_many :path_points, inverse_of: :path
  #has_many :trips, inverse_of: :path

  #alias_method :uncached_path_points, :path_points

  @@_p = []
  @@_id = nil

  def self.new_from_csv(row)
    p = path row[:shape_id]
    p << PathPoint.new(index: row[:shape_pt_sequence].to_i, lat: row[:shape_pt_lat].to_f, lng: row[:shape_pt_lon].to_f)
  end

  def self.path(shape_id)
    if @@_id.nil? or @@_id != shape_id
      unless @@_p.empty?
        p = Path.new _id: @@_id
        p.path_points = @@_p
        p.save
      end
      @@_p.clear
      @@_id = shape_id
    end
    @@_p
  end

  def self.skip_bulk_insert?
    true
  end

  def self.skip_final_bulk_insert?
    unless @@_p.empty?
      p = Path.new _id: @@_id
      p.path_points = @@_p
      p.save
    end
    @@_p = nil
    @@_id = nil
    true
  end

  def self.for_uuid uuid_str
    key = Uuid.key_for uuid_str
    Path.find key unless key.nil?
  end

  def self.for_route_and_calendars(route, calendars)
    Rails.cache.fetch("path_for_route_#{route.id}_calendar_#{calendars.collect(&:id).join ','}", expires_in: 1.hour) do
      Trip.where('route._id' => route.id).where(:calendar_id.in => calendars).collect(&:path).uniq
    end
  end

  def uuid
    Uuid.for self
  end

  #def path_points
  #  Rails.cache.fetch("path_points_#{id}") { uncached_path_points.to_a }
  #end
end
