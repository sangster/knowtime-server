class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.references :user, index: true
      t.decimal :lat, precision: 14, scale: 10
      t.decimal :lng, precision: 14, scale: 10

      t.timestamps
    end
  end
end
