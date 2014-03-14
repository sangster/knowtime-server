class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :stop_id
      t.string :stop_name
      t.float :stop_lat
      t.float :stop_lon

      t.datetime :created_at
    end

    add_index :stops, :stop_id
    add_index :stops, :stop_lat
    add_index :stops, :stop_lon
  end
end
