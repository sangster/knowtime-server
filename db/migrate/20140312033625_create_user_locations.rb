class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.integer :user_id
      t.float :lat
      t.float :lon
      t.datetime :created_at
    end

    add_index :user_locations, :user_id
    add_index :user_locations, :created_at
  end
end
