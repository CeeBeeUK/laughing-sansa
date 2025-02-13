# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2015_03_30_212732) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "event_player_scores", id: :serial, force: :cascade do |t|
    t.integer "event_player_id"
    t.integer "participating_country_id"
    t.integer "score"
    t.boolean "best_wail"
    t.boolean "fattest"
    t.boolean "wackiest"
    t.string "notes"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["event_player_id"], name: "index_event_player_scores_on_event_player_id"
    t.index ["participating_country_id"], name: "index_event_player_scores_on_participating_country_id"
  end

  create_table "event_players", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "event_id"
    t.integer "predicted_uk_score"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["event_id"], name: "index_event_players_on_event_id"
    t.index ["player_id", "event_id"], name: "unique_player_and_event", unique: true
    t.index ["player_id"], name: "index_event_players_on_player_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.integer "year"
    t.integer "country_id"
    t.string "host_city"
    t.boolean "active"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "real_winner_id"
    t.integer "real_score"
    t.integer "real_player_id"
    t.string "real_player_name"
    t.integer "home_winner_id"
    t.integer "home_score"
    t.integer "home_player_id"
    t.string "home_player_name"
    t.integer "status"
    t.date "date"
    t.integer "actual_uk_score"
    t.index ["country_id"], name: "index_events_on_country_id"
    t.index ["home_player_id"], name: "index_events_on_home_player_id"
    t.index ["home_winner_id"], name: "index_events_on_home_winner_id"
    t.index ["real_player_id"], name: "index_events_on_real_player_id"
    t.index ["real_winner_id"], name: "index_events_on_real_winner_id"
  end

  create_table "participating_countries", id: :serial, force: :cascade do |t|
    t.integer "country_id"
    t.integer "event_id"
    t.integer "player_id"
    t.integer "real_final_score"
    t.integer "home_final_score"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "position"
    t.index ["country_id", "event_id"], name: "unique_country_for_event", unique: true
    t.index ["country_id"], name: "index_participating_countries_on_country_id"
    t.index ["event_id"], name: "index_participating_countries_on_event_id"
    t.index ["player_id"], name: "index_participating_countries_on_player_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
    t.string "image"
    t.string "provider"
    t.string "uid"
    t.string "role"
    t.string "last_name"
    t.string "first_name"
    t.string "display_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
