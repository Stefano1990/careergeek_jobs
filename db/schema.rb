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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130215221028) do

  create_table "candidates", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "city"
    t.string   "country"
    t.string   "linkedin"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "title"
    t.string   "location"
    t.date     "start_date"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.text     "about_this_job"
    t.text     "requirements"
    t.text     "how_to_apply"
    t.integer  "category_id"
    t.date     "application_deadline"
    t.integer  "recruiter_id"
  end

  create_table "recruiters", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "name"
    t.string   "surname"
    t.string   "city"
    t.string   "country"
    t.string   "company"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "password_confirmation"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "views", :force => true do |t|
    t.integer  "job_id"
    t.string   "ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
