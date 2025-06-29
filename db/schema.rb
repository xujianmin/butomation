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

ActiveRecord::Schema[8.0].define(version: 2025_06_26_081518) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "lottery_id", null: false
    t.integer "virtual_users_count", default: 0, null: false
    t.datetime "joined_at", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lottery_id", "status", "user_id"], name: "index_attendances_on_lottery_status_user"
    t.index ["lottery_id", "status"], name: "index_attendances_on_lottery_id_and_status"
    t.index ["lottery_id"], name: "index_attendances_on_lottery_id"
    t.index ["status"], name: "index_attendances_on_status"
    t.index ["user_id", "lottery_id"], name: "index_attendances_on_user_id_and_lottery_id", unique: true
    t.index ["user_id", "status"], name: "index_attendances_on_user_id_and_status"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "lotteries", force: :cascade do |t|
    t.string "title"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string "target_url"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "priority"
    t.string "status"
    t.string "meeting_url"
    t.string "meeting_code"
    t.index ["user_id"], name: "index_lotteries_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expires_at"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "sites_pokermons", force: :cascade do |t|
    t.string "nickname"
    t.string "kana"
    t.string "registry_cellphone"
    t.string "registry_postcode"
    t.string "registry_fandi"
    t.string "reg_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "virtual_user_id", null: false
    t.index ["virtual_user_id"], name: "index_sites_pokermons_on_virtual_user_id"
  end

  create_table "subordinations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "virtual_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "virtual_user_id"], name: "index_subordinations_on_user_id_and_virtual_user_id", unique: true
    t.index ["user_id"], name: "index_subordinations_on_user_id"
    t.index ["virtual_user_id"], name: "index_subordinations_on_virtual_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "virtual_users", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "gender"
    t.string "email"
    t.string "civ_style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birthdate"
    t.string "domain"
  end

  add_foreign_key "attendances", "lotteries"
  add_foreign_key "attendances", "users"
  add_foreign_key "lotteries", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "sites_pokermons", "virtual_users"
  add_foreign_key "subordinations", "users"
  add_foreign_key "subordinations", "virtual_users"
end
