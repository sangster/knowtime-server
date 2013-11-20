class CreateStopTimes < ActiveRecord::Migration
  def change
    create_table :stop_times do |t|
      t.references :stop, index: true
      t.references :trip, index: true
      t.integer :index
      t.integer :arrival, index: true
      t.integer :departure, index: true
    end
  end
end
