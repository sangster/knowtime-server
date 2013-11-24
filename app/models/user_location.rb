class UserLocation < ActiveRecord::Base
  include Distanceable

  belongs_to :user, inverse_of: :user_locations

  def to_s
    "<UserLocation: lat: #{lat}, lng: #{lng}>"
  end
end
