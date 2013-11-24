class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.integer :stop_number, index: true
      t.text :name
      t.decimal :lat, precision: 14, scale: 10
      t.decimal :lng, precision: 14, scale: 10
    end
  end
end
