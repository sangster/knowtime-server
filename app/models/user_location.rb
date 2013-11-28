class UserLocation
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Distanceable

  field :t, as: :lat, type: Float
  field :g, as: :lng, type: Float

  embedded_in :user, inverse_of: :user_locations

  scope :newest, -> { where :created_at.gt => (DateTime.now - 30.seconds) }

  def to_s
    "<UserLocation: lat: #{lat}, lng: #{lng}>"
  end
end
