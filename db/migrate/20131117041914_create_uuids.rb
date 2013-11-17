class CreateUuids < ActiveRecord::Migration
  def change
    create_table :uuids do |t|
      t.uuid :uuid
      t.int :idable_id
      t.string :idable_type
      t.timestamps
    end
  end
end
