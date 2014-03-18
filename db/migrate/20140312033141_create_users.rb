class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :users do |t|
      t.uuid :uuid, default: 'uuid_generate_v4()', unique: true
      t.string :route_short_name
      t.boolean :moving_flag, default: false

      t.timestamps
    end

    add_index :users, :uuid
    add_index :users, :route_short_name
    add_index :users, :moving_flag
  end
end
