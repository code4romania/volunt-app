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

ActiveRecord::Schema.define(version: 20161027065046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "communications", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.string   "name",                       null: false
    t.datetime "scheduled_time"
    t.text     "description"
    t.integer  "template_id"
    t.text     "body"
    t.string   "tags",                                    array: true
    t.integer  "status",         default: 0, null: false
    t.integer  "flags",          default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["name"], name: "index_communications_on_name", unique: true, using: :btree
    t.index ["tags"], name: "index_communications_on_tags", using: :gin
    t.index ["template_id"], name: "index_communications_on_template_id", using: :btree
    t.index ["user_id"], name: "index_communications_on_user_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "full_name"
    t.string   "nick_name"
    t.string   "email"
    t.json     "contacts"
    t.string   "location"
    t.string   "photo"
    t.string   "curriculum"
    t.text     "description"
    t.jsonb    "urls"
    t.string   "title"
    t.string   "workplace"
    t.string   "tags",                                 array: true
    t.string   "skills",                               array: true
    t.integer  "status",      default: 0, null: false
    t.integer  "flags",       default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["email"], name: "index_profiles_on_email", unique: true, using: :btree
    t.index ["full_name"], name: "index_profiles_on_full_name", using: :btree
    t.index ["skills"], name: "index_profiles_on_skills", using: :gin
    t.index ["tags"], name: "index_profiles_on_tags", using: :gin
  end

  create_table "project_members", force: :cascade do |t|
    t.string   "role"
    t.integer  "project_id",             null: false
    t.integer  "profile_id",             null: false
    t.integer  "status",     default: 0, null: false
    t.integer  "flags",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["profile_id", "project_id"], name: "index_project_members_on_profile_id_and_project_id", unique: true, using: :btree
    t.index ["profile_id"], name: "index_project_members_on_profile_id", using: :btree
    t.index ["project_id", "profile_id"], name: "index_project_members_on_project_id_and_profile_id", unique: true, using: :btree
    t.index ["project_id"], name: "index_project_members_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",                    null: false
    t.text     "description"
    t.string   "tags",                                 array: true
    t.integer  "status",      default: 0, null: false
    t.integer  "flags",       default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.jsonb    "urls"
    t.integer  "owner_id"
    t.index ["name"], name: "index_projects_on_name", unique: true, using: :btree
    t.index ["owner_id"], name: "index_projects_on_owner_id", using: :btree
    t.index ["tags"], name: "index_projects_on_tags", using: :gin
    t.index ["urls"], name: "index_projects_on_urls", using: :gin
  end

  create_table "recipients", force: :cascade do |t|
    t.integer  "communication_id",             null: false
    t.integer  "profile_id",                   null: false
    t.text     "last_exception"
    t.datetime "scheduled_time"
    t.integer  "retry_count",      default: 0, null: false
    t.datetime "delivery_time"
    t.integer  "status",           default: 0, null: false
    t.integer  "flags",            default: 0, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["communication_id"], name: "index_recipients_on_communication_id", using: :btree
    t.index ["profile_id"], name: "index_recipients_on_profile_id", using: :btree
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name",                   null: false
    t.string   "subject"
    t.text     "body"
    t.string   "tags",                                array: true
    t.integer  "status",     default: 0, null: false
    t.integer  "flags",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["name"], name: "index_templates_on_name", unique: true, using: :btree
    t.index ["tags"], name: "index_templates_on_tags", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                     null: false
    t.binary   "password_hash"
    t.integer  "status",        default: 0, null: false
    t.integer  "flags",         default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "validation_tokens", force: :cascade do |t|
    t.binary   "token",       null: false
    t.integer  "user_id"
    t.integer  "category",    null: false
    t.datetime "valid_until"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["token"], name: "index_validation_tokens_on_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_validation_tokens_on_user_id", using: :btree
  end

  add_foreign_key "communications", "templates"
  add_foreign_key "communications", "users"
  add_foreign_key "project_members", "profiles"
  add_foreign_key "project_members", "projects"
  add_foreign_key "recipients", "communications"
  add_foreign_key "recipients", "profiles"
end
