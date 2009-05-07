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

data_source = DataSource.find(OPTIONS[:identifier])
data_url = data_source.data_url || nil rescue nil
raise "DataSource with id #{OPTIONS[:identifier]} is not found" unless data_source
raise "Repository URL is not given" unless data_url
raise "Cannot connect to the given URL" unless GNI::Url.new(data_url).valid?

data_extention = data_url.split(".").last
data_extention = '' unless ["zip","xml"].include? data_extention
base_dir = "#{RAILS_ROOT}/repositories/"
data_file = "#{base_dir}#{data_source.id}.#{data_extention.downcase}"

f = open(data_file,  "w")
f.write(open(data_url).read)
f.close

sha = IO.popen("sha1sum " + data_file).read.split(/\s+/)[0]
if data_source.data_hash != sha
  data_source.data_hash = sha
  data_source.save!
else
  puts "sha did not change"
end