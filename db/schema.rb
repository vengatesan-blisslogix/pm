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

ActiveRecord::Schema.define(version: 20170217045511) do

  create_table "activity_masters", force: :cascade do |t|
    t.string   "activity_Name",        limit: 255
    t.string   "active",               limit: 255
    t.string   "activity_description", limit: 255
    t.string   "is_page",              limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "parent_id",            limit: 4
    t.string   "href",                 limit: 255
    t.string   "icon",                 limit: 255
  end

  create_table "assigns", force: :cascade do |t|
    t.integer  "taskboard_id",     limit: 4
    t.integer  "assigned_user_id", limit: 4
    t.integer  "assigneer_id",     limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "track_id",         limit: 4
  end

  create_table "billable_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "active",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "branches", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "active",     limit: 255
    t.integer  "user_id",    limit: 4
  end

  create_table "business_units", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "active",      limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "checklist_rejects", force: :cascade do |t|
    t.string   "stage_name",   limit: 255
    t.text     "reason",       limit: 65535
    t.integer  "user_id",      limit: 4
    t.integer  "checklist_id", limit: 4
    t.integer  "taskboard_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.date     "date"
  end

  create_table "checklists", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "active",      limit: 255
    t.integer  "user_id",     limit: 4
    t.string   "stage",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "stage_value", limit: 4
  end

  create_table "client_sources", force: :cascade do |t|
    t.string   "source_name", limit: 255
    t.string   "description", limit: 255
    t.string   "active",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
  end

  create_table "clients", force: :cascade do |t|
    t.string   "client_name",         limit: 255
    t.string   "client_company_name", limit: 255
    t.string   "web_address",         limit: 255
    t.string   "first_address",       limit: 255
    t.string   "second_address",      limit: 255
    t.string   "city",                limit: 255
    t.string   "state",               limit: 255
    t.string   "country",             limit: 255
    t.string   "zip_code",            limit: 255
    t.string   "region",              limit: 255
    t.string   "client_email",        limit: 255
    t.string   "mobile",              limit: 255
    t.string   "phone1",              limit: 255
    t.string   "phone2",              limit: 255
    t.string   "fax",                 limit: 255
    t.string   "skypke",              limit: 255
    t.integer  "star_rating",         limit: 4
    t.string   "active",              limit: 255
    t.text     "comments",            limit: 65535
    t.string   "tag",                 limit: 255
    t.string   "archived",            limit: 255
    t.integer  "client_source_id",    limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id",             limit: 4
  end

  create_table "companies", force: :cascade do |t|
    t.string   "company_name",   limit: 255
    t.string   "display_name",   limit: 255
    t.string   "web_address",    limit: 255
    t.string   "first_address",  limit: 255
    t.string   "second_address", limit: 255
    t.string   "city",           limit: 255
    t.string   "state",          limit: 255
    t.string   "country",        limit: 255
    t.string   "zip_code",       limit: 255
    t.string   "region",         limit: 255
    t.string   "email",          limit: 255
    t.string   "mobile",         limit: 255
    t.string   "phone1",         limit: 255
    t.string   "phone2",         limit: 255
    t.string   "fax",            limit: 255
    t.string   "skype",          limit: 255
    t.integer  "star_rating",    limit: 4
    t.string   "active",         limit: 255
    t.string   "comments",       limit: 255
    t.string   "company_logo",   limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "cron_intranets", force: :cascade do |t|
    t.string   "emp_codes",        limit: 255
    t.string   "emp_name",         limit: 255
    t.string   "emp_gender",       limit: 255
    t.date     "emp_doj"
    t.string   "emp_status",       limit: 255
    t.string   "emp_reporting_to", limit: 255
    t.string   "emp_department",   limit: 255
    t.string   "emp_location",     limit: 255
    t.string   "emp_company",      limit: 255
    t.string   "emp_current_exp",  limit: 255
    t.string   "emp_previous_exp", limit: 255
    t.string   "emp_total_exp",    limit: 255
    t.boolean  "emp_left_org"
    t.datetime "emp_dob"
    t.datetime "emp_dow"
    t.string   "emp_blood_group",  limit: 255
    t.string   "emp_phone",        limit: 255
    t.string   "emp_mobile",       limit: 255
    t.string   "emp_email",        limit: 255
    t.string   "emp_photo",        limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "cron_reportings", force: :cascade do |t|
    t.integer  "reporting_id",   limit: 4
    t.string   "reporting_name", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "engagement_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "active",      limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "holidays", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "description", limit: 255
  end

  create_table "logtimes", force: :cascade do |t|
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "taskboard_id",       limit: 4
    t.integer  "project_master_id",  limit: 4
    t.integer  "sprint_planning_id", limit: 4
    t.integer  "task_master_id",     limit: 4
    t.integer  "user_id",            limit: 4
    t.date     "task_date"
    t.float    "task_time",          limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "approved_by",        limit: 255
    t.datetime "approved_at"
    t.string   "rejected_by",        limit: 255
    t.datetime "rejected_at"
    t.string   "comments",           limit: 255
    t.string   "status",             limit: 255
  end

  create_table "percentages", force: :cascade do |t|
    t.integer  "value",      limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "project_boards", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "project_domains", force: :cascade do |t|
    t.string   "domain_name", limit: 255
    t.integer  "active",      limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "project_locations", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "active",      limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "project_masters", force: :cascade do |t|
    t.string   "billable",                 limit: 255
    t.string   "project_name",             limit: 255
    t.text     "description",              limit: 65535
    t.string   "project_image",            limit: 255
    t.integer  "domain_id",                limit: 4
    t.integer  "client_id",                limit: 4
    t.integer  "created_by_user_id",       limit: 4
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "project_status_master_id", limit: 4
    t.string   "website",                  limit: 255
    t.string   "facebook_page",            limit: 255
    t.string   "twitter_page",             limit: 255
    t.integer  "star_rating",              limit: 4
    t.string   "active",                   limit: 255
    t.string   "tag_keywords",             limit: 255
    t.integer  "flag_id",                  limit: 4
    t.string   "approved",                 limit: 255
    t.integer  "approved_by_user_id",      limit: 4
    t.datetime "approved_date_time"
    t.integer  "assigned_to_user_id",      limit: 4
    t.date     "kickstart_date"
    t.integer  "project_type_id",          limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "avatar_file_name",         limit: 255
    t.string   "avatar_content_type",      limit: 255
    t.integer  "avatar_file_size",         limit: 4
    t.datetime "avatar_updated_at"
    t.string   "sow_number",               limit: 255
    t.string   "account_manager",          limit: 255
    t.string   "project_manager",          limit: 255
    t.string   "business_unit_id",         limit: 255
    t.string   "project_location_id",      limit: 255
    t.string   "engagement_type_id",       limit: 255
    t.string   "project_payment_id",       limit: 255
    t.integer  "account_manager_id",       limit: 4
    t.integer  "project_manager_id",       limit: 4
  end

  create_table "project_payments", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "active",      limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "project_request_forms", force: :cascade do |t|
    t.string   "project_name",               limit: 255
    t.string   "project_manager",            limit: 255
    t.integer  "project_type_id",            limit: 4
    t.string   "billable",                   limit: 255
    t.text     "project_description",        limit: 65535
    t.integer  "project_domain_id",          limit: 4
    t.string   "client_name",                limit: 255
    t.date     "kickstart_date"
    t.date     "planned_start_date"
    t.date     "planned_end_date"
    t.string   "tag_keyword",                limit: 255
    t.integer  "project_status_master_id",   limit: 4
    t.integer  "project_location_id",        limit: 4
    t.string   "sow_no",                     limit: 255
    t.boolean  "signoff_attachment"
    t.string   "account_manager_name",       limit: 255
    t.string   "website_page",               limit: 255
    t.string   "facebook_page",              limit: 255
    t.string   "twitter_page",               limit: 255
    t.integer  "business_unit_id",           limit: 4
    t.integer  "enagement_type_id",          limit: 4
    t.string   "payment_cylce",              limit: 255
    t.string   "team_member_allocation",     limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "signed_copy_file_name",      limit: 255
    t.string   "signed_copy_content_type",   limit: 255
    t.integer  "signed_copy_file_size",      limit: 4
    t.datetime "signed_copy_updated_at"
    t.string   "mail_approval_file_name",    limit: 255
    t.string   "mail_approval_content_type", limit: 255
    t.integer  "mail_approval_file_size",    limit: 4
    t.datetime "mail_approval_updated_at"
    t.date     "signoff_date"
    t.integer  "project_manager_id",         limit: 4
    t.integer  "payment_cycle_id",           limit: 4
  end

  create_table "project_status_masters", force: :cascade do |t|
    t.string   "status",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "active",      limit: 4
    t.integer  "user_id",     limit: 4
    t.string   "description", limit: 255
  end

  create_table "project_task_attachments", force: :cascade do |t|
    t.integer  "project_task_id",     limit: 4
    t.integer  "updated_by",          limit: 4
    t.integer  "delete_status",       limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
  end

  create_table "project_task_mappings", force: :cascade do |t|
    t.date     "assign_date"
    t.date     "completed_date"
    t.string   "planned_duration",      limit: 255
    t.string   "actual_duration",       limit: 255
    t.integer  "assigned_by",           limit: 4
    t.string   "active",                limit: 255
    t.string   "priority",              limit: 255
    t.integer  "sprint_planning_id",    limit: 4
    t.integer  "task_status_master_id", limit: 4
    t.integer  "project_task_id",       limit: 4
    t.integer  "project_master_id",     limit: 4
    t.integer  "release_planning_id",   limit: 4
    t.integer  "user_id",               limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "project_task_reasons", force: :cascade do |t|
    t.integer  "project_task_id",   limit: 4
    t.text     "date_reason",       limit: 65535
    t.text     "hour_reason",       limit: 65535
    t.integer  "created_by",        limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "project_master_id", limit: 4
    t.date     "sch_start"
    t.date     "sch_end"
    t.integer  "delayed_type",      limit: 4
  end

  create_table "project_tasks", force: :cascade do |t|
    t.string   "task_name",         limit: 255
    t.text     "task_description",  limit: 65535
    t.integer  "project_board_id",  limit: 4
    t.integer  "project_master_id", limit: 4
    t.string   "active",            limit: 255
    t.float    "planned",           limit: 24
    t.float    "actual",            limit: 24
    t.date     "planned_duration"
    t.date     "actual_duration"
    t.integer  "priority_id",       limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "is_delete",         limit: 4
    t.text     "reason",            limit: 65535
    t.date     "sc_start"
    t.date     "sc_end"
    t.integer  "delay_type",        limit: 4
  end

  create_table "project_time_sheets", force: :cascade do |t|
    t.date     "duration_in_hours"
    t.datetime "date_time"
    t.string   "comments",              limit: 255
    t.string   "timesheet_status",      limit: 255
    t.integer  "approved_by",           limit: 4
    t.integer  "project_master_id",     limit: 4
    t.integer  "task_status_master_id", limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "project_types", force: :cascade do |t|
    t.string   "project_name", limit: 255
    t.integer  "active",       limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "project_users", force: :cascade do |t|
    t.date     "assigned_date"
    t.date     "relieved_date"
    t.string   "active",            limit: 255
    t.integer  "utilization",       limit: 4
    t.string   "is_billable",       limit: 255
    t.integer  "project_master_id", limit: 4
    t.integer  "user_id",           limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "client_id",         limit: 4
    t.integer  "manager",           limit: 4
    t.string   "reporting_to",      limit: 255
    t.integer  "allocate",          limit: 4
    t.integer  "default_project",   limit: 4
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "release_planning_reasons", force: :cascade do |t|
    t.integer  "release_planning_id", limit: 4
    t.text     "date_reason",         limit: 65535
    t.text     "hour_reason",         limit: 65535
    t.integer  "created_by",          limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "project_master_id",   limit: 4
    t.date     "sch_start"
    t.date     "sch_end"
    t.integer  "delayed_type",        limit: 4
  end

  create_table "release_plannings", force: :cascade do |t|
    t.string   "release_name",           limit: 255
    t.float    "planned_hours",          limit: 24
    t.float    "actual_hours",           limit: 24
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "project_master_id",      limit: 4
    t.integer  "user_id",                limit: 4
    t.text     "comments",               limit: 65535
    t.string   "active",                 limit: 255
    t.text     "release_notes",          limit: 65535
    t.string   "flag_name",              limit: 255
    t.integer  "approved",               limit: 4
    t.integer  "approved_by_user_id",    limit: 4
    t.string   "qa_approved",            limit: 255
    t.integer  "qa_approved_by_user_id", limit: 4
    t.datetime "qa_approved_date_time"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "sprint_status_id",       limit: 4
    t.text     "reason",                 limit: 65535
    t.date     "sc_start"
    t.date     "sc_end"
    t.integer  "delay_type",             limit: 4
  end

  create_table "releases", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "released_on"
    t.integer  "project_id",  limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "role_activity_mappings", force: :cascade do |t|
    t.integer  "role_master_id",     limit: 4
    t.integer  "activity_master_id", limit: 4
    t.integer  "access_value",       limit: 4
    t.integer  "user_id",            limit: 4
    t.integer  "active",             limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "role_masters", force: :cascade do |t|
    t.string   "role_name",   limit: 255
    t.string   "active",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "description", limit: 255
  end

  create_table "sprint_planning_reasons", force: :cascade do |t|
    t.integer  "sprint_planning_id", limit: 4
    t.text     "date_reason",        limit: 65535
    t.text     "hour_reason",        limit: 65535
    t.integer  "created_by",         limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "project_master_id",  limit: 4
    t.date     "sch_start"
    t.date     "sch_end"
    t.integer  "delayed_type",       limit: 4
  end

  create_table "sprint_plannings", force: :cascade do |t|
    t.string   "active",              limit: 255
    t.float    "planned_hours",       limit: 24
    t.float    "actual_hours",        limit: 24
    t.date     "start_date"
    t.date     "end_date"
    t.string   "sprint_name",         limit: 255
    t.text     "sprint_desc",         limit: 65535
    t.integer  "sprint_status_id",    limit: 4
    t.integer  "project_master_id",   limit: 4
    t.integer  "release_planning_id", limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "reason",              limit: 65535
    t.date     "sc_start"
    t.date     "sc_end"
    t.integer  "delay_type",          limit: 4
  end

  create_table "sprint_statuses", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.integer  "active",     limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sprints", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "status_id",  limit: 4
    t.integer  "project_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "task_priorities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "task_status_masters", force: :cascade do |t|
    t.string   "status",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "description", limit: 255
  end

  create_table "taskboards", force: :cascade do |t|
    t.string   "status",                limit: 255
    t.string   "description",           limit: 255
    t.integer  "est_time",              limit: 4
    t.integer  "task_complete",         limit: 4
    t.integer  "task_status_master_id", limit: 4
    t.integer  "project_master_id",     limit: 4
    t.integer  "sprint_planning_id",    limit: 4
    t.integer  "task_master_id",        limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.float    "p_hours",          limit: 24
    t.float    "c_hours",          limit: 24
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "assignee_id",      limit: 4
    t.integer  "assigner_id",      limit: 4
    t.integer  "task_priority_id", limit: 4
    t.integer  "project_board_id", limit: 4
    t.integer  "project_id",       limit: 4
    t.integer  "sprint_id",        limit: 4
    t.integer  "release_id",       limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "team_masters", force: :cascade do |t|
    t.string   "team_name",   limit: 255
    t.string   "description", limit: 255
    t.string   "active",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
  end

  create_table "technology_masters", force: :cascade do |t|
    t.string   "technology",  limit: 255
    t.string   "active",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
    t.string   "description", limit: 255
  end

  create_table "timesheets", force: :cascade do |t|
    t.integer  "project_master_id", limit: 4
    t.integer  "project_task_id",   limit: 4
    t.integer  "user_id",           limit: 4
    t.date     "task_date"
    t.float    "task_time",         limit: 24
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "todotasklists", force: :cascade do |t|
    t.string   "task_name",       limit: 255
    t.integer  "created_by_user", limit: 4
    t.integer  "closed_by_user",  limit: 4
    t.integer  "status",          limit: 4
    t.integer  "remainder",       limit: 4
    t.integer  "archive",         limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "todotaskmappings", force: :cascade do |t|
    t.integer  "todotasklist_id", limit: 4
    t.integer  "created_by_user", limit: 4
    t.integer  "closed_by_user",  limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "todotaskshares", force: :cascade do |t|
    t.integer  "todotasklist_id", limit: 4
    t.integer  "shared_by",       limit: 4
    t.integer  "shared_to",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "user_favourites", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "user_technologies", force: :cascade do |t|
    t.integer  "technology_master_id", limit: 4
    t.integer  "user_id",              limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               limit: 255,   default: "email", null: false
    t.string   "uid",                    limit: 255,   default: "",      null: false
    t.string   "encrypted_password",     limit: 255,   default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "name",                   limit: 255
    t.string   "nickname",               limit: 255
    t.string   "image",                  limit: 255
    t.string   "email",                  limit: 255
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile_no",              limit: 255
    t.string   "office_phone",           limit: 255
    t.string   "home_phone",             limit: 255
    t.string   "profile_photo",          limit: 255
    t.string   "active",                 limit: 255
    t.float    "prior_experience",       limit: 24
    t.date     "doj"
    t.date     "dob"
    t.integer  "team_id",                limit: 4
    t.string   "last_name",              limit: 255
    t.string   "created_by_user",        limit: 255
    t.string   "reporting_to",           limit: 255
    t.integer  "branch_id",              limit: 4
    t.integer  "company_id",             limit: 4
    t.integer  "role_master_id",         limit: 4
    t.integer  "otp",                    limit: 4
    t.string   "original_password",      limit: 255
    t.string   "password",               limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.string   "employee_no",            limit: 255
    t.float    "tvs_experience",         limit: 24
    t.float    "total_experience",       limit: 24
    t.integer  "delivery",               limit: 4
    t.integer  "reporting_to_id",        limit: 4
    t.string   "reporting_id",           limit: 255
    t.integer  "default_project_id",     limit: 4
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
