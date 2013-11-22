class UserLocation < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_locations
end
