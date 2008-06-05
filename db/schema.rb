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

ActiveRecord::Schema.define(:version => 20080605085300) do

  create_table "access_rules", :force => true do |t|
    t.integer  "data_source_id"
    t.integer  "access_type_id"
    t.boolean  "is_allowed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "access_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_provider_roles", :force => true do |t|
    t.integer  "data_provider_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "uri_type_id"
    t.integer  "response_format_id"
    t.integer  "refresh_period_hours"
    t.string   "taxonomic_scope"
    t.string   "geospatial_scope_wkt"
    t.boolean  "in_gni"
    t.date     "created"
    t.date     "updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kingdoms", :force => true do |t|
    t.integer  "name_string_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "name_indices", :force => true do |t|
    t.integer  "name_string_id"
    t.integer  "data_source_id"
    t.integer  "response_format_id"
    t.integer  "kingdom_id"
    t.string   "uri"
    t.integer  "uri_type_id"
    t.datetime "created"
    t.datetime "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "name_strings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_contacts", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "person_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.integer  "organization_id"
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
    t.integer  "organization_id"
    t.integer  "person_id"
    t.string   "type"
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

  create_table "response_formats", :force => true do |t|
    t.string   "response_format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uri_types", :force => true do |t|
    t.string   "uri_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
