#!/usr/bin/env ruby

#this script should be run by cron
require 'optparse'

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
require 'statistic'
require 'name_string'

ns_count = NameString.count
Statistic.name_strings_count = ns_count


