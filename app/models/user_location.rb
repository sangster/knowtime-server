class UserLocation
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Distanceable

  field :t, as: :lat, type: Float
  field :g, as: :lng, type: Float

  embedded_in :user, inverse_of: :user_locations

  scope :newer_than, -> (age) { where :created_at.gt => (DateTime.now - age) }
  scope :newest, -> { newer_than 30.seconds }

  def to_s
    "<UserLocation: lat: #{lat}, lng: #{lng}>"
  end
end
