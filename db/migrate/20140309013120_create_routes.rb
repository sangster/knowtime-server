class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :route_id
      t.string :route_short_name
      t.string :route_long_name
      t.integer :route_type

      t.datetime :created_at
    end

    add_index :routes, :route_id
    add_index :routes, :route_short_name
  end
end
