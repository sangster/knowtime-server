class PathPoint
  include Mongoid::Document

  embedded_in :path, inverse_of: :path_points

  field :p, as: :path_id, type: String
  field :i, as: :index, type: Integer
  field :t, as: :lat, type: Float
  field :g, as: :lng, type: Float
end
