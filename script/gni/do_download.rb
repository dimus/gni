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

data_source_id = OPTIONS[:identifier]
data_url = DataSource.find(data_source_id).data_url || nil rescue nil
raise "Repository URL is not given" unless data_url

raise "Cannot connect to the given URL" unless GniUrl.valid_url?(data_url)

data_extention = data_url.split(".").last
data_extention = '' unless ["zip","xml"].include? data_extention
base_dir = "#{RAILS_ROOT}/repositories/"
data_file = "#{base_dir}#{data_source_id}.#{data_extention}"

f = open(data_file,  "w")
f.write(open(data_url).read)
f.close
FileUtils.rm_rf("#{base_dir}tmp")
Dir.chdir "#{base_dir}"
system "unzip -d tmp #{data_source_id}.zip"

