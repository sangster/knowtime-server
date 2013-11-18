class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.uuid :uuid, index: true
      t.text :short_name, index: true

      t.timestamps
    end
  end
end
