class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.text :headsign
      t.references :route, index: true
      t.references :calendar, index: true
      t.references :path, index: true

      t.timestamps
    end
  end
end
