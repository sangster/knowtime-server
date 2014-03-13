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

ActiveRecord::Schema.define(version: 20140312033625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "calendar_dates", force: true do |t|
    t.string   "service_id"
    t.date     "date"
    t.integer  "exception_type"
    t.datetime "created_at"
  end

  add_index "calendar_dates", ["service_id"], name: "index_calendar_dates_on_service_id", using: :btree

  create_table "calendars", force: true do |t|
    t.string   "service_id"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
  end

  create_table "data_pulls", force: true do |t|
    t.string   "url"
    t.string   "etag"
    t.datetime "created_at"
  end

  add_index "data_pulls", ["url"], name: "index_data_pulls_on_url", using: :btree

  create_table "routes", force: true do |t|
    t.string   "route_id"
    t.string   "route_short_name"
    t.string   "route_long_name"
    t.integer  "route_type"
    t.datetime "created_at"
  end

  add_index "routes", ["route_id"], name: "index_routes_on_route_id", using: :btree
  add_index "routes", ["route_short_name"], name: "index_routes_on_route_short_name", using: :btree

  create_table "shapes", force: true do |t|
    t.string   "shape_id"
    t.float    "shape_pt_lat"
    t.float    "shape_pt_lon"
    t.integer  "shape_pt_sequence"
    t.datetime "created_at"
  end

  add_index "shapes", ["shape_id"], name: "index_shapes_on_shape_id", using: :btree
  add_index "shapes", ["shape_pt_lat"], name: "index_shapes_on_shape_pt_lat", using: :btree
  add_index "shapes", ["shape_pt_lon"], name: "index_shapes_on_shape_pt_lon", using: :btree

  create_table "stop_times", force: true do |t|
    t.string   "stop_id"
    t.string   "trip_id"
    t.integer  "arrival_time"
    t.integer  "departure_time"
    t.integer  "stop_sequence"
    t.datetime "created_at"
  end

  add_index "stop_times", ["arrival_time"], name: "index_stop_times_on_arrival_time", using: :btree
  add_index "stop_times", ["departure_time"], name: "index_stop_times_on_departure_time", using: :btree
  add_index "stop_times", ["stop_id"], name: "index_stop_times_on_stop_id", using: :btree
  add_index "stop_times", ["trip_id"], name: "index_stop_times_on_trip_id", using: :btree

  create_table "stops", force: true do |t|
    t.string   "stop_id"
    t.string   "stop_name"
    t.float    "stop_lat"
    t.float    "stop_lon"
    t.datetime "created_at"
  end

  add_index "stops", ["stop_id"], name: "index_stops_on_stop_id", using: :btree
  add_index "stops", ["stop_lat"], name: "index_stops_on_stop_lat", using: :btree
  add_index "stops", ["stop_lon"], name: "index_stops_on_stop_lon", using: :btree

  create_table "trips", force: true do |t|
    t.string   "trip_id"
    t.string   "block_id"
    t.string   "trip_headsign"
    t.string   "route_id"
    t.string   "service_id"
    t.string   "shape_id"
    t.datetime "created_at"
  end

  add_index "trips", ["block_id"], name: "index_trips_on_block_id", using: :btree
  add_index "trips", ["route_id"], name: "index_trips_on_route_id", using: :btree
  add_index "trips", ["service_id"], name: "index_trips_on_service_id", using: :btree
  add_index "trips", ["shape_id"], name: "index_trips_on_shape_id", using: :btree
  add_index "trips", ["trip_id"], name: "index_trips_on_trip_id", using: :btree

  create_table "user_locations", force: true do |t|
    t.integer  "user_id"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
  end

  add_index "user_locations", ["created_at"], name: "index_user_locations_on_created_at", using: :btree
  add_index "user_locations", ["user_id"], name: "index_user_locations_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.uuid     "uuid",             default: "uuid_generate_v4()"
    t.string   "route_short_name"
    t.boolean  "moving_flag",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["moving_flag"], name: "index_users_on_moving_flag", using: :btree
  add_index "users", ["route_short_name"], name: "index_users_on_route_short_name", using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", using: :btree

end
