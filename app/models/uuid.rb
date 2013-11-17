class Uuid < ActiveRecord::Base
  belongs_to :idable, polymorphic: true
end
