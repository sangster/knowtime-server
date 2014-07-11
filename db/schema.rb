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

ActiveRecord::Schema.define(version: 20140407020017) do

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

  create_table "gtfs_engine_agencies", force: true do |t|
    t.string  "agency_id"
    t.string  "agency_name",     null: false
    t.string  "agency_url",      null: false
    t.string  "agency_timezone", null: false
    t.string  "agency_lang"
    t.string  "agency_fare_url"
    t.string  "agency_phone"
    t.integer "data_set_id",     null: false
  end

  add_index "gtfs_engine_agencies", ["agency_id"], name: "index_gtfs_engine_agencies_on_agency_id", using: :btree
  add_index "gtfs_engine_agencies", ["data_set_id"], name: "index_gtfs_engine_agencies_on_data_set_id", using: :btree

  create_table "gtfs_engine_calendar_dates", force: true do |t|
    t.string  "service_id",     null: false
    t.date    "date",           null: false
    t.integer "exception_type", null: false
    t.integer "data_set_id",    null: false
  end

  add_index "gtfs_engine_calendar_dates", ["data_set_id"], name: "index_gtfs_engine_calendar_dates_on_data_set_id", using: :btree
  add_index "gtfs_engine_calendar_dates", ["date"], name: "index_gtfs_engine_calendar_dates_on_date", using: :btree
  add_index "gtfs_engine_calendar_dates", ["service_id"], name: "index_gtfs_engine_calendar_dates_on_service_id", using: :btree

  create_table "gtfs_engine_calendars", force: true do |t|
    t.string  "service_id",  null: false
    t.boolean "monday",      null: false
    t.boolean "tuesday",     null: false
    t.boolean "wednesday",   null: false
    t.boolean "thursday",    null: false
    t.boolean "friday",      null: false
    t.boolean "saturday",    null: false
    t.boolean "sunday",      null: false
    t.date    "start_date",  null: false
    t.date    "end_date",    null: false
    t.integer "data_set_id", null: false
  end

  add_index "gtfs_engine_calendars", ["data_set_id"], name: "index_gtfs_engine_calendars_on_data_set_id", using: :btree
  add_index "gtfs_engine_calendars", ["end_date"], name: "index_gtfs_engine_calendars_on_end_date", using: :btree
  add_index "gtfs_engine_calendars", ["service_id"], name: "index_gtfs_engine_calendars_on_service_id", using: :btree
  add_index "gtfs_engine_calendars", ["start_date"], name: "index_gtfs_engine_calendars_on_start_date", using: :btree

  create_table "gtfs_engine_data_sets", force: true do |t|
    t.string   "name",       null: false
    t.string   "url",        null: false
    t.string   "etag",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gtfs_engine_data_sets", ["name"], name: "index_gtfs_engine_data_sets_on_name", using: :btree
  add_index "gtfs_engine_data_sets", ["url"], name: "index_gtfs_engine_data_sets_on_url", using: :btree

  create_table "gtfs_engine_fare_attributes", force: true do |t|
    t.string  "fare_id",           null: false
    t.float   "price",             null: false
    t.string  "currency_type",     null: false
    t.integer "payment_method",    null: false
    t.integer "transfers"
    t.integer "transfer_duration"
    t.integer "data_set_id",       null: false
  end

  add_index "gtfs_engine_fare_attributes", ["data_set_id"], name: "index_gtfs_engine_fare_attributes_on_data_set_id", using: :btree
  add_index "gtfs_engine_fare_attributes", ["fare_id"], name: "index_gtfs_engine_fare_attributes_on_fare_id", using: :btree

  create_table "gtfs_engine_fare_rules", force: true do |t|
    t.string  "fare_id",        null: false
    t.string  "route_id"
    t.string  "origin_id"
    t.string  "destination_id"
    t.string  "contains_id"
    t.integer "data_set_id",    null: false
  end

  add_index "gtfs_engine_fare_rules", ["data_set_id"], name: "index_gtfs_engine_fare_rules_on_data_set_id", using: :btree
  add_index "gtfs_engine_fare_rules", ["fare_id"], name: "index_gtfs_engine_fare_rules_on_fare_id", using: :btree

  create_table "gtfs_engine_feed_infos", force: true do |t|
    t.string  "feed_publisher_name", null: false
    t.string  "feed_publisher_url",  null: false
    t.string  "feed_lang",           null: false
    t.date    "feed_start_date"
    t.date    "feed_end_date"
    t.string  "feed_version"
    t.integer "data_set_id",         null: false
  end

  add_index "gtfs_engine_feed_infos", ["data_set_id"], name: "index_gtfs_engine_feed_infos_on_data_set_id", using: :btree

  create_table "gtfs_engine_frequencies", force: true do |t|
    t.string  "trip_id",      null: false
    t.integer "start_time",   null: false
    t.integer "end_time",     null: false
    t.integer "headway_secs", null: false
    t.boolean "exact_times"
    t.integer "data_set_id",  null: false
  end

  add_index "gtfs_engine_frequencies", ["data_set_id"], name: "index_gtfs_engine_frequencies_on_data_set_id", using: :btree
  add_index "gtfs_engine_frequencies", ["trip_id"], name: "index_gtfs_engine_frequencies_on_trip_id", using: :btree

  create_table "gtfs_engine_routes", force: true do |t|
    t.string  "route_id",         null: false
    t.string  "agency_id"
    t.string  "route_short_name", null: false
    t.string  "route_long_name",  null: false
    t.string  "route_desc"
    t.integer "route_type",       null: false
    t.integer "route_url"
    t.string  "route_color"
    t.string  "route_text_color"
    t.integer "data_set_id",      null: false
  end

  add_index "gtfs_engine_routes", ["data_set_id"], name: "index_gtfs_engine_routes_on_data_set_id", using: :btree
  add_index "gtfs_engine_routes", ["route_id"], name: "index_gtfs_engine_routes_on_route_id", using: :btree
  add_index "gtfs_engine_routes", ["route_short_name"], name: "index_gtfs_engine_routes_on_route_short_name", using: :btree

  create_table "gtfs_engine_shapes", force: true do |t|
    t.string  "shape_id",            null: false
    t.float   "shape_pt_lat",        null: false
    t.float   "shape_pt_lon",        null: false
    t.integer "shape_pt_sequence",   null: false
    t.float   "shape_dist_traveled"
    t.integer "data_set_id",         null: false
  end

  add_index "gtfs_engine_shapes", ["data_set_id"], name: "index_gtfs_engine_shapes_on_data_set_id", using: :btree
  add_index "gtfs_engine_shapes", ["shape_id"], name: "index_gtfs_engine_shapes_on_shape_id", using: :btree
  add_index "gtfs_engine_shapes", ["shape_pt_lat"], name: "index_gtfs_engine_shapes_on_shape_pt_lat", using: :btree
  add_index "gtfs_engine_shapes", ["shape_pt_lon"], name: "index_gtfs_engine_shapes_on_shape_pt_lon", using: :btree
  add_index "gtfs_engine_shapes", ["shape_pt_sequence"], name: "index_gtfs_engine_shapes_on_shape_pt_sequence", using: :btree

  create_table "gtfs_engine_stop_times", force: true do |t|
    t.string  "stop_id",             null: false
    t.string  "trip_id",             null: false
    t.integer "arrival_time",        null: false
    t.integer "departure_time",      null: false
    t.integer "stop_sequence",       null: false
    t.string  "stop_headsign"
    t.integer "pickup_type"
    t.integer "drop_off_type"
    t.float   "shape_dist_traveled"
    t.integer "data_set_id",         null: false
  end

  add_index "gtfs_engine_stop_times", ["arrival_time"], name: "index_gtfs_engine_stop_times_on_arrival_time", using: :btree
  add_index "gtfs_engine_stop_times", ["data_set_id"], name: "index_gtfs_engine_stop_times_on_data_set_id", using: :btree
  add_index "gtfs_engine_stop_times", ["departure_time"], name: "index_gtfs_engine_stop_times_on_departure_time", using: :btree
  add_index "gtfs_engine_stop_times", ["stop_id"], name: "index_gtfs_engine_stop_times_on_stop_id", using: :btree
  add_index "gtfs_engine_stop_times", ["trip_id"], name: "index_gtfs_engine_stop_times_on_trip_id", using: :btree

  create_table "gtfs_engine_stops", force: true do |t|
    t.string  "stop_id",             null: false
    t.string  "stop_code"
    t.string  "stop_name",           null: false
    t.string  "stop_desc"
    t.float   "stop_lat",            null: false
    t.float   "stop_lon",            null: false
    t.string  "zone_id"
    t.string  "stop_url"
    t.integer "location_type"
    t.integer "parent_station"
    t.string  "stop_timezone"
    t.integer "wheelchair_boarding"
    t.integer "data_set_id",         null: false
  end

  add_index "gtfs_engine_stops", ["data_set_id"], name: "index_gtfs_engine_stops_on_data_set_id", using: :btree
  add_index "gtfs_engine_stops", ["stop_code"], name: "index_gtfs_engine_stops_on_stop_code", using: :btree
  add_index "gtfs_engine_stops", ["stop_id"], name: "index_gtfs_engine_stops_on_stop_id", using: :btree
  add_index "gtfs_engine_stops", ["stop_lat"], name: "index_gtfs_engine_stops_on_stop_lat", using: :btree
  add_index "gtfs_engine_stops", ["stop_lon"], name: "index_gtfs_engine_stops_on_stop_lon", using: :btree
  add_index "gtfs_engine_stops", ["zone_id"], name: "index_gtfs_engine_stops_on_zone_id", using: :btree

  create_table "gtfs_engine_transfers", force: true do |t|
    t.string  "from_stop_id",      null: false
    t.string  "to_stop_id",        null: false
    t.integer "transfer_type",     null: false
    t.integer "min_transfer_time"
    t.integer "data_set_id",       null: false
  end

  add_index "gtfs_engine_transfers", ["data_set_id"], name: "index_gtfs_engine_transfers_on_data_set_id", using: :btree
  add_index "gtfs_engine_transfers", ["from_stop_id"], name: "index_gtfs_engine_transfers_on_from_stop_id", using: :btree
  add_index "gtfs_engine_transfers", ["to_stop_id"], name: "index_gtfs_engine_transfers_on_to_stop_id", using: :btree

  create_table "gtfs_engine_trips", force: true do |t|
    t.string  "trip_id",               null: false
    t.string  "service_id",            null: false
    t.string  "trip_headsign"
    t.string  "trip_short_name"
    t.integer "direction_id"
    t.string  "block_id"
    t.string  "route_id",              null: false
    t.string  "shape_id"
    t.integer "wheelchair_accessible"
    t.integer "bikes_allowed"
    t.integer "data_set_id",           null: false
  end

  add_index "gtfs_engine_trips", ["block_id"], name: "index_gtfs_engine_trips_on_block_id", using: :btree
  add_index "gtfs_engine_trips", ["data_set_id"], name: "index_gtfs_engine_trips_on_data_set_id", using: :btree
  add_index "gtfs_engine_trips", ["route_id"], name: "index_gtfs_engine_trips_on_route_id", using: :btree
  add_index "gtfs_engine_trips", ["service_id"], name: "index_gtfs_engine_trips_on_service_id", using: :btree
  add_index "gtfs_engine_trips", ["shape_id"], name: "index_gtfs_engine_trips_on_shape_id", using: :btree
  add_index "gtfs_engine_trips", ["trip_id"], name: "index_gtfs_engine_trips_on_trip_id", using: :btree

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
