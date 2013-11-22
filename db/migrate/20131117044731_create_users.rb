class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.binary :uuid, index: true, limit: 16
      t.text :short_name, index: true
    end
  end
end
