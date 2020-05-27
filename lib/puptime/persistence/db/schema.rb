# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_200_526_144_321) do
  create_table "service_dns", force: :cascade do |t|
    t.integer "service_id", null: false
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_tcp", force: :cascade do |t|
    t.integer "service_id", null: false
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.string "group"
    t.string "service_type", null: false
    t.string "interval", null: false
    t.integer "error_level", default: 0, null: false
    t.string "address"
    t.string "custom1"
    t.string "custom2"
    t.text "misc"
    t.index ["group"], name: "index_services_on_group"
    t.index ["interval"], name: "index_services_on_interval"
    t.index ["name"], name: "index_services_on_name"
    t.index [nil], name: "index_services_on_type"
  end
end
