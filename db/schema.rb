# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 6) do

  create_table "data_providers", :force => true do |t|
    t.integer  "data_source_id"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_sources", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "rights"
    t.string   "citation"
    t.string   "metadata_url"
    t.string   "endpoint_url"
    t.string   "data_uri"
    t.string   "data_uri_type"
    t.string   "response_format"
    t.integer  "refresh_perion_hours"
    t.string   "taxonomic_scope"
    t.string   "geospation_scope_wkt"
    t.boolean  "in_gni"
    t.date     "created"
    t.date     "updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "identifier"
    t.string   "acronym"
    t.string   "logo_url"
    t.string   "description"
    t.string   "address"
    t.float    "decimal_latitude"
    t.float    "decimal_longitude"
    t.string   "related_information_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participant_contacts", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "person_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participants", :force => true do |t|
    t.string   "type"
    t.integer  "organization_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.string   "email"
    t.string   "telephone"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
