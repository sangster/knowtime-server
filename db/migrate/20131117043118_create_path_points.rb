class CreatePathPoints < ActiveRecord::Migration
  def change
    create_table :path_points do |t|
      t.references :path, index: true
      t.float :lat
      t.float :lng
      t.integer :index

      t.timestamps
    end
  end
end
