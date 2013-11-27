class PathPoint
  include Mongoid::Document

  embedded_in :path

  field :p, as: :path_id, type: String
  field :i, as: :index, type: Integer
  field :t, as: :lat, type: Float
  field :g, as: :lng, type: Float

  #belongs_to :path, inverse_of: :path_points
end
