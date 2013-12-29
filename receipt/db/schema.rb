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

ActiveRecord::Schema.define(:version => 20130707093106) do

  create_table "items", :force => true do |t|
    t.string   "description"
    t.integer  "quantity"
    t.decimal  "price",       :default => 0.0
    t.boolean  "is_exempt",   :default => false
    t.boolean  "is_import",   :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "orders", :force => true do |t|
    t.decimal  "tax_total",       :default => 0.0
    t.decimal  "item_total",      :default => 0.0
    t.decimal  "sales_tax_rate",  :default => 0.1
    t.decimal  "import_tax_rate", :default => 0.05
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

end
