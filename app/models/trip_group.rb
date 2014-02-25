class TripGroup
  include Mongoid::Document

  field :_id, type: String
  has_many :trips

  def self.create_groups
    Trip.distinct( :trip_group_id ).each do |group_id|
      TripGroup.create! _id: group_id
    end 
  end
end
