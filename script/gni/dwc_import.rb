#!/usr/bin/env ruby

#this script should be run by cron
require 'optparse'
require 'fileutils'
require 'open-uri'

OPTIONS = {
  :environment => "production",
  :identifier => nil
}
CACHE = {}

ARGV.options do |opts|
  script_name = File.basename($0)
  opts.banner = "Usage: ruby #{script_name} [options]"

  opts.separator ""

  opts.on("-e", "--environment=name", String,
          "Specifies the environment to create the account under (test/development/production).",
          "Default: production") { |OPTIONS[:environment]| }

  opts.separator ""

  opts.on("-i", "--identifier=id", Numeric, "Specifies which data_source data to download") {|OPTIONS[:identifier]|}

  opts.separator ""

  opts.on("-h", "--help",
          "Show this help message.") { puts opts; exit }

  opts.parse!
  unless OPTIONS[:identifier]
    puts "Please enter the id of your repository"
    exit
  end
end

ENV["RAILS_ENV"] = OPTIONS[:environment]
require File.dirname(__FILE__) + "/../../config/environment"
require 'data_source'
require 'name_string'
require 'gni'

def fetch_name_string_id(value)
  raise "Name String should not be empty" if value.to_s == ''
  c = ActiveRecord::Base.connection
  normalized_name = NameString.normalize_name_string(value)
  ns_id = c.select_value("select id from name_strings where normalized_name = '#{normalized_name}'")
  unless  ns_id
    ns_id = c.insert("insert into name_strings (name, normalized_name, created_at, updated_at) values ('#{value}', '#{normalized_name}', now(), now())")
  end
  ns_id
end

def insert_data(data)
  c = ActiveRecord::Base.connection
  inserts = c.sanitize_sql_array [""]
end

def fetch_id(key, value)
  return nil if value.to_s.strip.blank?
  table = key.to_s.gsub(/_id$/,'').pluralize
  c = ActiveRecord::Base.connection
  unless CACHE[table]
    CACHE[table] = {} 
    res = c.select_all("select id, name from #{table}")
    res.each do |r|
      CACHE[table][r[:name]] = r[:id]
    end
  end
  
  value_id = CACHE[table][value.to_s.strip.downcase]
  return value_id if value_id
  
  value_id = c.insert("insert into #{table} (name,created_at, updated_at) values ('#{value}',now(),now())")
  puts value_id
end


data_source = DataSource.find(OPTIONS[:identifier])
data_url = data_source.data_url || nil rescue nil
raise "DataSource with id #{OPTIONS[:identifier]} is not found." unless data_source
raise "Repository URL is not given." unless data_url
raise "Cannot connect to the given URL." unless GniUrl.valid_url?(data_url)
base_dir = "#{RAILS_ROOT}/repositories/"
data_file = "#{base_dir}#{data_source.id}.zip"

open(data_file) rescue raise "Data file for #{data_source.title} does not exist."

FileUtils.rm_rf("#{base_dir}tmp")
Dir.chdir "#{base_dir}"
system "unzip -d tmp #{data_source.id}.zip"

Dir.chdir "tmp"
entries =  Dir.entries "."

dwc_file = 'darwin_core.txt'
links_file = 'links.txt'

if entries.include?('archive')
  dwc_file = 'archive/' + dwc_file
  links_file = 'archive/' + links_file
end


dwc = open(dwc_file)

lines = IO.popen("wc -l " + dwc_file).read.split(/\s+/)[0].to_i

links = open(links_file)
count = 0
mistakes = []
data = []
dwc_set = [:darwin_core_star_id, :local_id, :global_id, :name_string_id, :name_rank_id, :nomenclatural_code_id, :kingdom_id, :modified]
dwc.each do |row|
  count += 1
  row.strip!
  unless GNI.utf8_string? row
    mistakes << row if mistakes.size < 100
    next
  end
  
  row = row.split("\t")
  if count == 1 && row[0].strip.downcase == 'taxonid'
    lines -= 1
    next
  end
  
  data_hash = {}
  (0...dwc_set.size).each do |i|
    if [:name_rank_id, :nomenclatural_code_id, :kingdom_id].include? dwc_set[i]
      row[i] = fetch_id(dwc_set[i],row[i])
    end
    fetch_name_string_id(row[i]) if dwc_set[i] == :name_string_id    
    data_hash[dwc_set[i]] = row[i]
    data << data_hash
    if count % 1000 == 0
      insert_data(data)
      data = []
    end
  end
  insert_data(data)
end



