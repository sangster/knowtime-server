class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.integer :stop_number, index: true
      t.text :name
      t.float :lat
      t.float :lng
    end
  end
end
