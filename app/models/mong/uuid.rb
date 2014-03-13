require 'uuidtools'

class Uuid
  include Mongoid::Document

  field :_id, type: String
  field :u, as: :uuid, type: BSON::Binary

  index uuid: 1

  #belongs_to :idable, polymorphic: true, autosave: true


  def self.for key
    Rails.cache.fetch "uuid_for_#{key}", expires_in: 1.hour do
      key = key.id if Mongoid::Document === key

      u = Uuid.where(_id: key).first_or_create! do |u|
        u.uuid = BSON::Binary.new UUIDTools::UUID.random_create.raw, :uuid
      end
      UUIDTools::UUID.parse_raw u.uuid.data
    end
  end

  def self.key_for uuid_str
    uuid = BSON::Binary.new UUIDTools::UUID.parse(uuid_str).raw, :uuid
    Uuid.where(uuid: uuid).first.id
  rescue
    nil
  end

  def self.from_trip_id(trip_id)
    pluck_uuid 'Trip', trip_id
  end

  def self.from_route_id(route_id)
    pluck_uuid 'Route', route_id
  end

  def self.from_calendar_id(calendar_id)
    pluck_uuid 'Calendar', calendar_id
  end

  def self.from_path_id(path_id)
    pluck_uuid 'Path', path_id
  end

  def self.pluck_uuid(type, id)
    key = "uuid_#{type}_id_#{id}"
    Rails.cache.fetch(key, eternal: true) do
      u = Uuid.where('idable_type = ? AND idable_id = ?', type, id).pluck(:uuid).first
      UUIDTools::UUID.parse_raw u
    end
  end

  def raw
    @_raw ||= uuid.raw
  end
end
