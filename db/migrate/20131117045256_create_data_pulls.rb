class CreateDataPulls < ActiveRecord::Migration
  def change
    create_table :data_pulls do |t|
      t.text :url
      t.text :etag
    end
  end
end
