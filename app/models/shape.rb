class Shape < ActiveRecord::Base
  scope :path, ->(shape_id){ where(shape_id: shape_id).order :shape_pt_sequence }
  belongs_to :trip, inverse_of: :shapes, shared_key: :shape_id

  alias_attribute :lat, :shape_pt_lat
  alias_attribute :lng, :shape_pt_lon
  alias_attribute :index, :shape_pt_sequence

  class << self
    def new_from_csv(row)
      new shape_id: row[:shape_id],
          shape_pt_lat: row[:shape_pt_lat].to_f,
          shape_pt_lon: row[:shape_pt_lon].to_f,
          shape_pt_sequence: row[:shape_pt_sequence].to_i
    end
  end
end
