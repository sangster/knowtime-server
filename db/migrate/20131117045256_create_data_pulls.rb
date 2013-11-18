class CreateDataPulls < ActiveRecord::Migration
  def change
    create_table :data_pulls do |t|
      t.text :url
      t.text :etag

      t.timestamps
    end
  end
end
