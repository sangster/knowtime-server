class UserLocation < ActiveRecord::Base
  include Distanceable

  belongs_to :user, inverse_of: :user_locations

  scope :newest, -> { where 'created_at > ?', (DateTime.now - 30.seconds) }

  def to_s
    "<UserLocation: lat: #{lat}, lng: #{lng}>"
  end
end
