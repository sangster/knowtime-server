require 'uuidtools'

class User < ActiveRecord::Base
  has_many :user_locations, inverse_of: :user

  def self.get user_uuid_str
    Rails.cache.fetch("user_#{user_uuid_str}", expires_in: 10.minutes) do
      find_by uuid: UUIDTools::UUID.parse(user_uuid_str).raw
    end
  end


  def uuid_str
    @_uuid_str ||= UUIDTools::UUID.parse_raw uuid
  end

end
