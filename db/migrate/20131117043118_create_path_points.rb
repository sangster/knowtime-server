class CreatePathPoints < ActiveRecord::Migration
  def change
    create_table :path_points do |t|
      t.references :path, index: true
      t.decimal :lat, precision: 14, scale: 10
      t.decimal :lng, precision: 14, scale: 10
      t.integer :index
    end
  end
end
