class Path < ActiveRecord::Base
  has_one :uuid, as: :idable


  def self.uuid_namespace
    Uuid.create_namespace 'Paths'
  end
end
