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
      uuid = Uuid.find_by_uuid uuid_str
      uuid.nil? ? nil : uuid.idable_id
    end

    Rails.cache.delete key if uuid_id.nil?
    uuid_id
  end


  def self.get namespace, str
    uuid_str = UUIDTools::UUID.sha1_create(namespace, str).to_s
    key = "uuid_#{uuid_str}"
    uuid = Rails.cache.fetch(key, eternal: true) { Uuid.find_by_uuid uuid_str }

    Rails.cache.delete key if uuid.nil?
    uuid
  end
end
