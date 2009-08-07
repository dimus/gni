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

PID_FILE = RAILS_ROOT + "/tmp/pids/downloader"

def running?(pid_file)
  File.exists? pid_file
end

def set_running(pid_file)
  f = open pid_file, 'w'
  f.write "#{Process.pid}\n"
  f.close
end

def set_not_running(pid_file)
  File.unlink pid_file
end

def kill
  if File.exists? PID_FILE
    f = open(PID_FILE)
    pid = f.read.strip
    f.close
    system("kill -9 #{pid}")
  end
end

exit if running? PID_FILE

set_running PID_FILE
begin
  gr = GNI::Reconciler.new
  gr.create_tables()
  gr.create_groups()
rescue RuntimeError
  raise 
ensure
  set_not_running PID_FILE
end
