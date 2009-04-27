#!/usr/bin/env ruby

#this script should be run by cron
require 'optparse'
require 'fileutils'
require 'open-uri'

OPTIONS = {
  :environment => "production",
  :identifier => nil
}

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
require 'gni'

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
dwc_set = [:darwin_core_star_id, :local_id, :global_id, :name_string, :rank, :code, :kingdom, :modified]
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
  <id term="http://rs.tdwg.org/dwc/terms/TaxonID" index="1"/>
   <field term="http://rs.tdwg.org/dwc/terms/GlobalUniqueIdentifier" index="2"/>
   <!-- a local identifier (often id from the resource database) -->
   <field term="http://purl.org/dc/terms/identifier" index="3"/>
   <field term="http://rs.tdwg.org/dwc/terms/ScientificName" index="4"/>
   <field term="http://rs.tdwg.org/dwc/terms/TaxonRank" index="5"/>
   <!-- enumeration as defined by dwc -->
   <field term="http://rs.tdwg.org/dwc/terms/NomenclaturalCode" index="6"/>
   <field term="http://rs.tdwg.org/dwc/terms/Kingdom" index="7"/>
   <field term="http://purl.org/dc/terms/modified" index="8"/>
  
   CREATE TABLE `import_name_index_records` (
     `id` int(11) NOT NULL auto_increment,
     `data_source_id` int(11) default NULL,
     `kingdom_id` int(11) default NULL,
     `name_string_id` int(11) default NULL,
     `name_string` varchar(255) default NULL,
     `record_hash` varchar(255) default NULL,
     `local_id` varchar(255) default NULL,
     `global_id` varchar(255) default NULL,
     `url` varchar(255) default NULL,
     `created_at` datetime default NULL,
     `updated_at` datetime default NULL,
     `name_rank_id` int(11) default NULL,
     PRIMARY KEY  (`id`),
  
  break if count > 10
end

