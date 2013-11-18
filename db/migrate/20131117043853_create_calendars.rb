class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.date :start_date, index: true
      t.date :end_date, index: true
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday

      t.timestamps
    end
  end
end
