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

ActiveRecord::Schema.define(version: 20170610222139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "links", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "url"
    t.string   "slug"
    t.datetime "reminder"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.uuid     "user_from_id"
    t.uuid     "metadata_id"
    t.index ["metadata_id"], name: "index_links_on_metadata_id", using: :btree
    t.index ["user_from_id"], name: "index_links_on_user_from_id", using: :btree
  end

  create_table "metadata", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.string   "description"
    t.string   "domain"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["url"], name: "index_metadata_on_url", using: :btree
  end

  create_table "teams", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "team_id"
    t.string   "name"
    t.boolean  "active",     default: true
    t.string   "domain"
    t.string   "token"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "user_tags", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id"
    t.uuid     "link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_user_tags_on_link_id", using: :btree
    t.index ["user_id", "link_id"], name: "index_user_tags_on_user_id_and_link_id", using: :btree
    t.index ["user_id"], name: "index_user_tags_on_user_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "slack_id"
    t.string   "slug"
    t.uuid     "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_id"], name: "index_users_on_slack_id", using: :btree
    t.index ["team_id"], name: "index_users_on_team_id", using: :btree
  end

end
