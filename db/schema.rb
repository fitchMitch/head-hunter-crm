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

ActiveRecord::Schema.define(version: 20171211124823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"
  enable_extension "unaccent"

  create_table "comactions", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id"
    t.integer  "mission_id"
    t.integer  "person_id"
    t.datetime "end_time"
    t.integer  "status",      default: 0
    t.integer  "action_type", default: 0
    t.index ["mission_id"], name: "index_comactions_on_mission_id", using: :btree
    t.index ["person_id"], name: "index_comactions_on_person_id", using: :btree
    t.index ["user_id"], name: "index_comactions_on_user_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "company_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["company_name"], name: "index_companies_on_company_name", using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "job_title"
    t.float    "salary"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "jj_job"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
    t.integer  "person_id"
    t.boolean  "no_end"
    t.index ["company_id"], name: "index_jobs_on_company_id", using: :btree
    t.index ["person_id"], name: "index_jobs_on_person_id", using: :btree
  end

  create_table "missions", force: :cascade do |t|
    t.string   "name"
    t.float    "reward"
    t.float    "paid_amount"
    t.float    "min_salary"
    t.float    "max_salary"
    t.string   "criteria"
    t.boolean  "signed"
    t.boolean  "is_done"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "person_id"
    t.integer  "company_id"
    t.date     "whished_start_date"
    t.integer  "status",             default: 0
    t.index ["company_id"], name: "index_missions_on_company_id", using: :btree
    t.index ["person_id"], name: "index_missions_on_person_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone_number"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "is_jj_hired"
    t.boolean  "is_client"
    t.text     "note"
    t.integer  "user_id"
    t.string   "cv_docx_file_name"
    t.string   "cv_docx_content_type"
    t.integer  "cv_docx_file_size"
    t.datetime "cv_docx_updated_at"
    t.integer  "approx_age"
    t.text     "cv_content"
    t.index ["email"], name: "index_people_on_email", using: :btree
    t.index ["user_id"], name: "index_people_on_user_id", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_foreign_key "comactions", "missions", on_delete: :cascade
  add_foreign_key "comactions", "people", on_delete: :cascade
  add_foreign_key "comactions", "users"
  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs", "people", on_delete: :cascade
  add_foreign_key "missions", "companies"
  add_foreign_key "missions", "people", on_delete: :cascade
  add_foreign_key "people", "users"
end
