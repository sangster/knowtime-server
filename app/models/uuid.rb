require 'uuidtools'

class Uuid < ActiveRecord::Base
  belongs_to :idable, polymorphic: true, autosave: true


  def self.create_namespace str
    UUIDTools::UUID.sha1_create UUIDTools::UUID_OID_NAMESPACE, str
  end


  def self.create namespace, str
    UUIDTools::UUID.sha1_create namespace, str
  end


  def self.get_id namespace, str
    uuid_str = UUIDTools::UUID.sha1_create(namespace, str).to_s
    key = "uuid_id_#{uuid_str}"

    uuid_id = Rails.cache.fetch(key, eternal: true) do
      uuid = Uuid.find_by uuid: uuid_str
      uuid.nil? ? nil : uuid.idable_id
    end

    Rails.cache.delete key if uuid_id.nil?
    uuid_id
  end


  def self.get namespace, str
    uuid_str = UUIDTools::UUID.sha1_create(namespace, str).to_s
    key = "uuid_#{uuid_str}"
    uuid = Rails.cache.fetch(key, eternal: true) { Uuid.find_by uuid: uuid_str }

    Rails.cache.delete key if uuid.nil?
    uuid
  end


  def self.from_trip_id trip_id
    pluck_uuid 'Trip', trip_id
  end


  def self.from_route_id route_id
    pluck_uuid 'Route', route_id
  end


  def self.from_calendar_id calendar_id
    pluck_uuid 'Calendar', calendar_id
  end


  def self.from_path_id path_id
    pluck_uuid 'Path', path_id
  end


  def self.pluck_uuid type, id
    key = "uuid_#{type}_id_#{id}"
    Rails.cache.fetch(key, eternal: true) do
      Uuid.where('idable_type = ? AND idable_id = ?', type, id).pluck(:uuid).first
    end
  end

end
