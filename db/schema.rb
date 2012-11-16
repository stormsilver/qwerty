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

ActiveRecord::Schema.define(:version => 20121116033007) do

  create_table "games", :force => true do |t|
    t.string   "phone_number"
    t.boolean  "active",              :default => false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "waiting_for_players", :default => true
    t.string   "last_text"
  end

  create_table "games_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "game_id"
  end

  create_table "rounds", :force => true do |t|
    t.string   "kind"
    t.integer  "game_id"
    t.text     "data"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "active",     :default => false
  end

  create_table "scores", :force => true do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.integer  "round_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stats", :force => true do |t|
    t.string   "key"
    t.float    "value",      :default => 0.0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "texts", :force => true do |t|
    t.string   "body"
    t.integer  "user_id"
    t.integer  "round_id"
    t.integer  "game_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "body_original"
  end

  create_table "twilio_numbers", :force => true do |t|
    t.string   "phone_number"
    t.string   "twid"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "phone_number"
    t.string   "nickname"
    t.integer  "area_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.datetime "queue_time"
  end

  add_index "users", ["queue_time"], :name => "index_users_on_queue_time"

end
