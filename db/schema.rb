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

ActiveRecord::Schema.define(version: 20150119125652) do

  create_table "addresses", force: true do |t|
    t.string   "street",     null: false
    t.string   "city",       null: false
    t.string   "country",    null: false
    t.integer  "zip_code",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facilities", force: true do |t|
    t.string   "name",       null: false
    t.integer  "address_id", null: false
    t.integer  "role_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facility_static_measures", force: true do |t|
    t.string   "name"
    t.float    "value"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "facility_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "granular_measures", force: true do |t|
    t.float    "value",      null: false
    t.date     "day",        null: false
    t.integer  "measure_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measures", force: true do |t|
    t.string   "name",        null: false
    t.float    "value",       null: false
    t.date     "start_date",  null: false
    t.date     "end_date",    null: false
    t.integer  "facility_id", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name",         null: false
    t.string   "company_name", null: false
    t.integer  "nif",          null: false
    t.string   "sector",       null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",                         null: false
    t.string   "last_name",                          null: false
    t.string   "email",                              null: false
    t.string   "encrypted_password",                 null: false
    t.integer  "address_id",                         null: false
    t.integer  "current_role",           default: 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
