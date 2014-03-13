class CreateCalendarDates < ActiveRecord::Migration
  def change
    create_table :calendar_dates do |t|
      t.string :service_id
      t.date :date
      t.integer :exception_type

      t.datetime :created_at
    end

    add_index :calendar_dates, :service_id
  end
end
