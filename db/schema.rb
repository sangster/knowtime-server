# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131126025545) do

  create_table "calendar_exceptions", force: true do |t|
    t.integer "calendar_id"
    t.date    "date"
  end

  add_index "calendar_exceptions", ["calendar_id"], name: "index_calendar_exceptions_on_calendar_id", using: :btree

  create_table "calendars", force: true do |t|
    t.date    "start_date"
    t.date    "end_date"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
  end

  create_table "data_pulls", force: true do |t|
    t.text "url"
    t.text "etag"
  end

  create_table "path_points", force: true do |t|
    t.integer "path_id"
    t.decimal "lat",     precision: 14, scale: 10
    t.decimal "lng",     precision: 14, scale: 10
    t.integer "index"
  end

  add_index "path_points", ["path_id"], name: "index_path_points_on_path_id", using: :btree

  create_table "paths", force: true do |t|
  end

  create_table "routes", force: true do |t|
    t.text "short_name"
    t.text "long_name"
  end

  create_table "stop_times", force: true do |t|
    t.integer "stop_id"
    t.integer "trip_id"
    t.integer "index"
    t.integer "arrival"
    t.integer "departure"
  end

  add_index "stop_times", ["stop_id"], name: "index_stop_times_on_stop_id", using: :btree
  add_index "stop_times", ["trip_id"], name: "index_stop_times_on_trip_id", using: :btree

  create_table "stops", force: true do |t|
    t.integer "stop_number"
    t.text    "name"
    t.decimal "lat",         precision: 14, scale: 10
    t.decimal "lng",         precision: 14, scale: 10
  end

  create_table "trips", force: true do |t|
    t.text    "headsign"
    t.integer "route_id"
    t.integer "calendar_id"
    t.integer "path_id"
  end

  add_index "trips", ["calendar_id"], name: "index_trips_on_calendar_id", using: :btree
  add_index "trips", ["path_id"], name: "index_trips_on_path_id", using: :btree
  add_index "trips", ["route_id"], name: "index_trips_on_route_id", using: :btree

  create_table "user_locations", force: true do |t|
    t.integer  "user_id"
    t.decimal  "lat",        precision: 14, scale: 10
    t.decimal  "lng",        precision: 14, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_locations", ["created_at"], name: "index_user_locations_on_created_at", using: :btree
  add_index "user_locations", ["user_id"], name: "index_user_locations_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.binary "uuid",       limit: 16
    t.text   "short_name"
  end

  create_table "uuids", force: true do |t|
    t.binary  "uuid",        limit: 16
    t.integer "idable_id"
    t.string  "idable_type"
  end

end
