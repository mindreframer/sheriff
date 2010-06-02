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

ActiveRecord::Schema.define(:version => 20100602080608) do

  create_table "alerts", :force => true do |t|
    t.integer  "severity",        :null => false
    t.string   "message",         :null => false
    t.integer  "validation_id",   :null => false
    t.string   "validation_type", :null => false
    t.integer  "report_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deputies", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "address",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deputies", ["address"], :name => "index_deputies_on_address", :unique => true

  create_table "deputy_plugins", :force => true do |t|
    t.integer  "plugin_id",  :null => false
    t.integer  "deputy_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["group_id", "name"], :name => "index_groups_on_group_id_and_name", :unique => true

  create_table "historic_values", :force => true do |t|
    t.integer  "report_id",   :null => false
    t.string   "value",       :null => false
    t.datetime "reported_at", :null => false
  end

  add_index "historic_values", ["report_id"], :name => "index_historic_values_on_report_id"

  create_table "plugins", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url"
    t.text     "code",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plugins", ["name"], :name => "index_plugins_on_name", :unique => true

  create_table "reports", :force => true do |t|
    t.integer  "group_id",    :null => false
    t.integer  "deputy_id",   :null => false
    t.string   "value",       :null => false
    t.string   "config"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "reported_at", :null => false
  end

  add_index "reports", ["deputy_id"], :name => "index_reports_on_deputy_id"
  add_index "reports", ["group_id", "deputy_id"], :name => "index_reports_on_group_id_and_deputy_id", :unique => true

  create_table "run_between_validations", :force => true do |t|
    t.integer  "start_seconds", :null => false
    t.integer  "end_seconds",   :null => false
    t.integer  "severity",      :null => false
    t.integer  "report_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "run_every_validations", :force => true do |t|
    t.integer  "interval",   :null => false
    t.integer  "severity",   :null => false
    t.integer  "report_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "value_validations", :force => true do |t|
    t.string   "value",      :null => false
    t.integer  "severity",   :null => false
    t.integer  "report_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
