class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.string :shape_id
      t.float :shape_pt_lat
      t.float :shape_pt_lon
      t.integer :shape_pt_sequence

      t.datetime :created_at
    end

    add_index :shapes, :shape_id
    add_index :shapes, :shape_pt_lat
    add_index :shapes, :shape_pt_lon
  end
end
