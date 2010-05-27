# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100527100331) do

  create_table "groups", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["group_id", "name"], :name => "index_groups_on_group_id_and_name", :unique => true

  create_table "reporters", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "address",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reporters", ["address"], :name => "index_reporters_on_address", :unique => true
  add_index "reporters", ["name"], :name => "index_reporters_on_name", :unique => true

  create_table "reports", :force => true do |t|
    t.integer  "group_id",    :null => false
    t.integer  "reporter_id", :null => false
    t.string   "value",       :null => false
    t.string   "config"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["group_id", "reporter_id"], :name => "index_reports_on_group_id_and_reporter_id", :unique => true
  add_index "reports", ["reporter_id"], :name => "index_reports_on_reporter_id"

end
