class CreateUuids < ActiveRecord::Migration
  def change
    create_table :uuids do |t|
      t.uuid :uuid, index: true
      t.references :idable, polymorphic: true
      t.timestamps
    end
  end
end
