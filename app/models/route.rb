class Route < ActiveRecord::Base
  has_many :trips, inverse_of: :route, shared_key: :route_id

  has_many :calendars, through: :trips
  has_many :shapes, through: :trips

  alias_attribute :short_name, :route_short_name
  alias_attribute :long_name, :route_long_name

  class << self
    def new_from_csv(row)
      new         route_id: row[:route_id],
          route_short_name: row[:route_short_name],
           route_long_name: row[:route_long_name],
                route_type: row[:route_type]
    end
  end
end
