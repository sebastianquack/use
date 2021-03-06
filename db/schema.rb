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

ActiveRecord::Schema.define(version: 20140117160042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "market_sessions", force: true do |t|
    t.integer  "duration"
    t.integer  "max_survivors"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ownerships", force: true do |t|
    t.integer  "stock_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.float    "investment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "profit"
    t.float    "avg_price"
  end

  create_table "settings", force: true do |t|
    t.float    "exchange_rate"
    t.float    "base_cash_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_sellout"
  end

  create_table "stocks", force: true do |t|
    t.string   "name"
    t.string   "symbol"
    t.text     "description"
    t.string   "utopist_name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "utopist_id"
    t.float    "investment"
    t.float    "base_price",   default: 0.0
  end

  create_table "transactions", force: true do |t|
    t.integer  "transaction_type_id"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.float    "price"
    t.integer  "amount"
    t.integer  "stock_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.float    "balance"
    t.string   "role"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cash_in"
    t.float    "profit"
    t.float    "investment"
  end

  create_table "utopias", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "realization"
    t.text     "risks"
    t.integer  "effect_body"
    t.integer  "effect_economy"
    t.integer  "effect_politics"
    t.integer  "effect_spirituality"
    t.integer  "effect_technology"
    t.integer  "effect_environment"
    t.integer  "effect_fun"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

end
