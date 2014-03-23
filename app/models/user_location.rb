class UserLocation < ActiveRecord::Base
  include Distanceable

  default_scope { order :created_at }
  scope :newer_than, ->(age) { where "created_at > ?", (Time.zone.now - age) }
  scope :newest, -> { newer_than 30.seconds }

  belongs_to :user, inverse_of: :user_locations, touch: true

  alias_attribute :lng, :lon
end
