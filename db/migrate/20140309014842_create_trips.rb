class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :trip_id
      t.string :block_id
      t.string :trip_headsign
      t.string :route_id
      t.string :service_id
      t.string :shape_id

      t.datetime :created_at
    end

    add_index :trips, :trip_id
    add_index :trips, :block_id
    add_index :trips, :route_id
    add_index :trips, :service_id
    add_index :trips, :shape_id
  end
end
