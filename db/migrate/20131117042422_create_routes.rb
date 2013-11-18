class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.text :short_name, index: true
      t.text :long_name

      t.timestamps
    end
  end
end
