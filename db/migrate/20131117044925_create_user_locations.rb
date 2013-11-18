class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.references :user, index: true
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
