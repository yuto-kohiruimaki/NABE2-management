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

ActiveRecord::Schema[8.0].define(version: 2025_11_24_122430) do
  create_table "monthly_notes", force: :cascade do |t|
    t.string "month", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["month"], name: "index_monthly_notes_on_month", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "place"
    t.string "name"
    t.text "desc"
    t.date "post_date"
    t.index ["post_date"], name: "index_posts_on_post_date"
    t.index ["user_id", "post_date"], name: "index_posts_on_user_id_and_post_date"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "timestamps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "name"
    t.string "place"
    t.string "desc"
    t.boolean "day_off", default: false
    t.datetime "start_time"
    t.datetime "finish_time"
    t.date "work_date"
    t.index ["user_id", "work_date"], name: "index_timestamps_on_user_id_and_work_date"
    t.index ["user_id"], name: "index_timestamps_on_user_id"
    t.index ["work_date"], name: "index_timestamps_on_work_date"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role", default: "employee", null: false
    t.boolean "is_deleted", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_deleted"], name: "index_users_on_is_deleted"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "work_plans", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "period", null: false
    t.integer "planned_working_days", default: 0, null: false
    t.integer "planned_working_hours"
    t.text "notes"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_work_plans_on_created_by_id"
    t.index ["user_id", "period"], name: "index_work_plans_on_user_id_and_period", unique: true
    t.index ["user_id"], name: "index_work_plans_on_user_id"
  end

  add_foreign_key "work_plans", "users"
  add_foreign_key "work_plans", "users", column: "created_by_id"
end
