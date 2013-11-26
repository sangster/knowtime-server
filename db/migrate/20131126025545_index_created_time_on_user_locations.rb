class IndexCreatedTimeOnUserLocations < ActiveRecord::Migration
  def change
    add_index :user_locations, :created_at
  end
end
