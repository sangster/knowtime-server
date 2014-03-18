class CreateStopTimes < ActiveRecord::Migration
  def change
    create_table :stop_times do |t|
      t.string :stop_id
      t.string :trip_id
      t.integer :arrival_time
      t.integer :departure_time
      t.integer :stop_sequence

      t.datetime :created_at
    end

    add_index :stop_times, :stop_id
    add_index :stop_times, :trip_id
    add_index :stop_times, :arrival_time
    add_index :stop_times, :departure_time
  end
end
