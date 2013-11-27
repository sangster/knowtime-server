require 'uuidtools'

class Uuid
  #belongs_to :idable, polymorphic: true, autosave: true


  def self.create_namespace(str)
    Rails.cache.fetch("uuid_namespace_#{str}", expires_in: 24.hours) do
      UUIDTools::UUID.sha1_create UUIDTools::UUID_OID_NAMESPACE, str
    end
  end

  def self.create(namespace, str)
    UUIDTools::UUID.sha1_create namespace, str
  end

  def self.find_idable(idable_type, uuid_str)
    key = "idable_#{idable_type}_#{uuid_str}"
    idable = Rails.cache.read key
    return idable unless idable.nil?

    idable = Uuid.find_by(idable_type: idable_type, uuid: UUIDTools::UUID.parse(uuid_str).raw).idable rescue nil
    unless idable.nil?
      idable.prepare_for_caching if idable.respond_to? :prepare_for_caching
      Rails.cache.write key, idable, expires_in: 1.hour
    end
    idable
  end

  def self.get_id(namespace, str)
    uuid_obj = UUIDTools::UUID.sha1_create(namespace, str)
    uuid_str = uuid_obj.to_s
    key = "uuid_id_#{uuid_str}"

    idable_id = Rails.cache.fetch(key, expires_in: 6.hours) do
      uuid = Uuid.find_by uuid: uuid_obj.raw
      if uuid.nil? then
        nil
      else
        uuid.idable_id
      end
    end

    Rails.cache.delete key if idable_id.nil?
    idable_id
  end

  def self.get(namespace, str)
    uuid_obj = UUIDTools::UUID.sha1_create(namespace, str)
    uuid_str = uuid_obj.to_s
    key = "uuid_#{uuid_str}"
    uuid = Rails.cache.fetch(key, expires_in: 6.hours) { Uuid.find_by uuid: uuid_obj.raw }

    Rails.cache.delete key if uuid.nil?
    uuid
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
