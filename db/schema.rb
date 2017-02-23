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

ActiveRecord::Schema.define(version: 20170223215624) do

  create_table "companies", force: :cascade do |t|
    t.string   "company_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "job_histories", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_job_histories_on_person_id"
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
    t.index ["company_id"], name: "index_jobs_on_company_id"
    t.index ["person_id"], name: "index_jobs_on_person_id"
  end

  create_table "missions", force: :cascade do |t|
    t.string   "name"
    t.float    "reward"
    t.float    "paid_amount"
    t.float    "min_salary"
    t.float    "max_salary"
    t.string   "criteria"
    t.integer  "min_age"
    t.integer  "max_age"
    t.boolean  "signed"
    t.boolean  "is_done"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "person_id"
    t.integer  "company_id"
    t.date     "whished_start_date"
    t.index ["company_id"], name: "index_missions_on_company_id"
    t.index ["person_id"], name: "index_missions_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string   "title"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone_number"
    t.string   "cell_phone_number"
    t.date     "birthdate"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "is_jj_hired"
    t.boolean  "is_client"
    t.text     "note"
    t.integer  "user_id"
    t.index ["email"], name: "index_people_on_email"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "people_tags", id: false, force: :cascade do |t|
    t.integer "tag_id",    null: false
    t.integer "person_id", null: false
    t.index ["person_id", "tag_id"], name: "index_people_tags_on_person_id_and_tag_id"
    t.index ["tag_id", "person_id"], name: "index_people_tags_on_tag_id_and_person_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

end
