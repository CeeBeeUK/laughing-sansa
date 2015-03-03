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

ActiveRecord::Schema.define(version: 20150303221438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "year"
    t.integer  "country_id"
    t.string   "host_city"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "real_winner_id"
    t.integer  "real_score"
    t.integer  "real_player_id"
    t.string   "real_player_name"
    t.integer  "home_winner_id"
    t.integer  "home_score"
    t.integer  "home_player_id"
    t.string   "home_player_name"
    t.integer  "status"
    t.date     "date"
  end

  add_index "events", ["country_id"], name: "index_events_on_country_id", using: :btree
  add_index "events", ["home_player_id"], name: "index_events_on_home_player_id", using: :btree
  add_index "events", ["home_winner_id"], name: "index_events_on_home_winner_id", using: :btree
  add_index "events", ["real_player_id"], name: "index_events_on_real_player_id", using: :btree
  add_index "events", ["real_winner_id"], name: "index_events_on_real_winner_id", using: :btree

  create_table "participating_countries", force: true do |t|
    t.integer  "country_id"
    t.integer  "event_id"
    t.integer  "sequence"
    t.integer  "player_id"
    t.integer  "real_final_score"
    t.integer  "home_final_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participating_countries", ["country_id", "event_id", "player_id"], name: "unique_player_and_country_for_event", unique: true, using: :btree
  add_index "participating_countries", ["country_id"], name: "index_participating_countries_on_country_id", using: :btree
  add_index "participating_countries", ["event_id", "sequence"], name: "unique_sequence_for_event", unique: true, using: :btree
  add_index "participating_countries", ["event_id"], name: "index_participating_countries_on_event_id", using: :btree
  add_index "participating_countries", ["player_id"], name: "index_participating_countries_on_player_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "image"
    t.string   "provider"
    t.string   "uid"
    t.string   "role"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "display_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
