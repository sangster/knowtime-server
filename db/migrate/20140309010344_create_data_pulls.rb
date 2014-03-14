class CreateDataPulls < ActiveRecord::Migration
  def change
    create_table :data_pulls do |t|
      t.string :url
      t.string :etag

      t.datetime :created_at
    end

    add_index :data_pulls, :url
  end
end
