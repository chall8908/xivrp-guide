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

ActiveRecord::Schema.define(version: 2021_04_15_234157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.string "server", null: false, comment: "Which server the event takes place on"
    t.string "location", null: false, comment: "Either a housing ward or a location in the world"
    t.integer "ward", comment: "Ward number for venues"
    t.integer "plot", comment: "Plot number for venues"
    t.string "nearest_aetherite", null: false
    t.string "timezone", null: false, comment: "Timezone this event was scheduled in.  Shared by all schedules"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "event_id"
    t.date "start_date", null: false, comment: "First day this schedule is valid"
    t.date "end_date", comment: "Last day this schedule is valid"
    t.string "times", null: false, comment: "Time range this schedule represents"
    t.boolean "sunday", default: false
    t.boolean "monday", default: false
    t.boolean "tuesday", default: false
    t.boolean "wednesday", default: false
    t.boolean "thursday", default: false
    t.boolean "friday", default: false
    t.boolean "saturday", default: false
    t.integer "repeat_interval", null: false
    t.string "repeat_unit", null: false, comment: "How often this schedule repeats: never, week, month, year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_schedules_on_event_id"
  end

  add_foreign_key "schedules", "events"
end
