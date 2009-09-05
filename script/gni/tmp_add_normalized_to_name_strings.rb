#!/usr/bin/env ruby

#this script should be run by cron
require 'optparse'
require 'fileutils'
require 'open-uri'

OPTIONS = {
  :environment => "production",
}

ARGV.options do |opts|
  script_name = File.basename($0)
  opts.banner = "Usage: ruby #{script_name} [options]"

  opts.separator ""

  opts.on("-e", "--environment=name", String,
          "Specifies the environment to create the account under (test/development/production).",
          "Default: production") { |OPTIONS[:environment]| }

  opts.separator ""

  opts.on("-h", "--help",
          "Show this help message.") { puts opts; exit }

  opts.parse!
end

ENV["RAILS_ENV"] = OPTIONS[:environment]
require File.dirname(__FILE__) + "/../../config/environment"
require 'taxamatch_rb'

c = ActiveRecord::Base.connection
c.execute("drop table if exists name_strings_tmp")
c.execute("create table name_strings_tmp like name_strings")

names = c.execute "select id, name, is_canonical_form, canonical_form_id, has_words, created_at, updated_at from name_strings order by id"
count = 0
c.execute "start transaction" 
names.each do |id, name, is_canonical_form, canonical_form_id, has_words, created_at, updated_at|
  count += 1
  if count % 10000 == 0
    puts count
    c.execute "commit" 
    c.execute "start transaction" 
  end
  normalized = ActiveRecord::Base.gni_sanitize_sql(["?", Taxamatch::Normalizer.normalize(name)])
  name = ActiveRecord::Base.gni_sanitize_sql(["?", name])
  c.execute "insert into name_strings_tmp (id, name, normalized, is_canonical_form, has_words, canonical_form_id, created_at, updated_at) values (%s, %s, %s, %s, %s, %s, '%s', '%s')" % [id, name, normalized, is_canonical_form, canonical_form_id, has_words, created_at, updated_at]
end
c.execute "commit"
