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

ActiveRecord::Schema.define(version: 20161230135739) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "game_tries", force: :cascade do |t|
    t.string   "game_token"
    t.string   "try"
    t.string   "result"
    t.integer  "seconds"
    t.boolean  "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.string   "token"
    t.string   "ip"
    t.string   "sequence"
    t.integer  "num_pos"
    t.boolean  "repeated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.string   "game_token"
    t.string   "user"
    t.integer  "tries"
    t.integer  "seconds"
    t.integer  "num_pos"
    t.boolean  "repeated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "points"
  end

end
