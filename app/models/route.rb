class Route < ActiveRecord::Base
  has_one :uuid, as: :idable


  def self.new_from_csv row
    route = Route.new short_name: row[:route_short_name], long_name: row[:route_long_name]
    route.build_uuid uuid: Uuid.create(uuid_namespace, row[:route_id]).to_s
    route
  end

  def self.uuid_namespace
    Uuid.create_namespace 'Routes'
  end
end
