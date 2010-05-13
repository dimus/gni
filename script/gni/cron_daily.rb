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
require 'data_source'
require 'import_scheduler'

def cleanup_orphans
  NameString.delete_orphans
end

def update_unique_names
  UniqueName.update_unique_names
end

def update_cached_counts
  ns_count = NameString.count
  Statistic.name_strings_count = ns_count
  DataSource.update_name_strings_count
  DataSource.update_unique_names_count
end

def set_repositories_que
  data_sources = DataSource.all(:select => 'id, refresh_period_days', :order => 'id desc')
  data_sources.each do |ds|
    if ImportScheduler.ready_to_schedule?(ds)
      ImportScheduler.create(:data_source_id => ds.id, :status => ImportScheduler::WAITING, :message => "Scheduled by daily process")
    end
  end
end

def do_repositories_update
  system(File.dirname(__FILE__) + "/update_imports -e " +  OPTIONS[:environment])
end

def generate_words
  nwp = GNI::NameWordsGenerator.new
  nwp.generate_words
end

#cleanup_orphans
update_unique_names
update_cached_counts
generate_words
ImportScheduler.run_scheduler
#set_repositories_que
#do_repositories_update
