class CreateUuids < ActiveRecord::Migration
  def change
    create_table :uuids do |t|
      t.binary :uuid, index: true, limit: 16
      t.references :idable, polymorphic: true
    end
  end
end
