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

ActiveRecord::Schema.define(version: 20160401071909) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_masters", force: :cascade do |t|
    t.string   "activity_Name"
    t.string   "active"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "parent_id"
    t.string   "href"
    t.string   "icon"
  end

  create_table "branches", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "active"
    t.integer  "user_id"
  end

  create_table "client_sources", force: :cascade do |t|
    t.string   "source_name"
    t.string   "description"
    t.string   "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "client_name"
    t.string   "client_company_name"
    t.string   "web_address"
    t.string   "first_address"
    t.string   "second_address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "region"
    t.string   "client_email"
    t.string   "mobile"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "skypke"
    t.integer  "star_rating"
    t.string   "active"
    t.string   "comments"
    t.string   "tag"
    t.string   "archived"
    t.integer  "client_source_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "company_name"
    t.string   "display_name"
    t.string   "web_address"
    t.string   "first_address"
    t.string   "second_address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "region"
    t.string   "email"
    t.string   "mobile"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "skype"
    t.integer  "star_rating"
    t.string   "active"
    t.string   "comments"
    t.string   "company_logo"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "project_masters", force: :cascade do |t|
    t.string   "billable"
    t.string   "project_name"
    t.string   "description"
    t.string   "project_image"
    t.integer  "domain_id"
    t.integer  "client_id"
    t.integer  "created_by_user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "project_status_id"
    t.string   "website"
    t.string   "facebook_page"
    t.string   "twitter_page"
    t.integer  "star_rating"
    t.string   "active"
    t.string   "tag_keywords"
    t.integer  "flag_id"
    t.string   "approved"
    t.integer  "approved_by_user_id"
    t.datetime "approved_date_time"
    t.integer  "assigned_to_user_id"
    t.date     "kickstart_date"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "project_status_masters", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "active"
    t.integer  "user_id"
  end

  create_table "project_task_mappings", force: :cascade do |t|
    t.date     "assign_date"
    t.date     "completed_date"
    t.string   "planned_duration"
    t.string   "actual_duration"
    t.integer  "assigned_by"
    t.string   "active"
    t.string   "priority"
    t.integer  "sprint_planning_id"
    t.integer  "task_status_id"
    t.integer  "project_task_id"
    t.integer  "project_id"
    t.integer  "release_id"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "project_tasks", force: :cascade do |t|
    t.string   "task_name"
    t.string   "task_description"
    t.string   "active"
    t.integer  "priority"
    t.datetime "planned_duration"
    t.datetime "actual_duration"
    t.integer  "project_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "project_time_sheets", force: :cascade do |t|
    t.date     "duration_in_hours"
    t.datetime "date_time"
    t.string   "comments"
    t.string   "timesheet_status"
    t.integer  "approved_by"
    t.integer  "project_id"
    t.integer  "task_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "project_users", force: :cascade do |t|
    t.date     "assigned_date"
    t.date     "relived_date"
    t.string   "active"
    t.float    "utilization"
    t.string   "is_billable"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "release_plannings", force: :cascade do |t|
    t.string   "release_name"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "comments"
    t.string   "active"
    t.string   "release_notes"
    t.integer  "approved"
    t.integer  "approved_by_user_id"
    t.string   "qa_approved"
    t.integer  "qa_approved_by_user_id"
    t.datetime "qa_approved_date_time"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "role_activity_mappings", force: :cascade do |t|
    t.integer  "role_master_id"
    t.integer  "activity_master_id"
    t.integer  "access_value"
    t.integer  "user_id"
    t.integer  "active"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "role_masters", force: :cascade do |t|
    t.string   "role_name"
    t.string   "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

  create_table "sprint_plannings", force: :cascade do |t|
    t.string   "active"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "sprint_name"
    t.string   "sprint_desc"
    t.integer  "sprint_status_id"
    t.integer  "project_id"
    t.integer  "release_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "task_status_masters", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_masters", force: :cascade do |t|
    t.string   "team_name"
    t.string   "description"
    t.string   "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "technology_masters", force: :cascade do |t|
    t.string   "technology"
    t.string   "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "user_technologies", force: :cascade do |t|
    t.integer  "technology_master_id"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
    t.integer  "company_id"
    t.integer  "role_master_id"
    t.integer  "otp"
    t.string   "password"
    t.string   "original_password"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "mobile_no"
    t.string   "office_phone"
    t.string   "home_phone"
    t.string   "profile_photo"
    t.string   "active"
    t.integer  "prior_experience"
    t.date     "doj"
    t.date     "dob"
    t.integer  "team_id"
    t.string   "last_name"
    t.string   "created_by_user"
    t.string   "reporting_to"
  end

  add_index "users", ["branch_id"], name: "index_users_on_branch_id", using: :btree
  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_master_id"], name: "index_users_on_role_master_id", using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "users", "branches"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "role_masters"
end
