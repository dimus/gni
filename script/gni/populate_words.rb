#!/usr/bin/env ruby

#this script should be run by cron
require 'optparse'

OPTIONS = {
  :environment => "development",
}

ARGV.options do |opts|
  script_name = File.basename($0)
  opts.banner = "Usage: ruby #{script_name} [options]"

  opts.separator ""

  opts.on("-e", "--environment=name", String,
          "Specifies the environment to create the account under (test/development/production).",
          "Default: production") { |opt| OPTIONS[:environment] = opt }

  opts.separator ""

  opts.on("-h", "--help",
          "Show this help message.") { puts opts; exit }

  opts.parse!
end

ENV["RAILS_ENV"] = OPTIONS[:environment]
require File.dirname(__FILE__) + "/../../config/environment"
puts OPTIONS[:environment]
require 'biodiversity'
require 'taxamatch_rb'

c = ActiveRecord::Base.connection
parser = ScientificNameParser.new


nwg = GNI::NameWordsGenerator.new
nwg.generate_words(true)

# create tables uninomial and genus tables
if 1 == 1
  ['genus'].each do |t|
    puts "creating #{t}_words"
    c.execute("drop table if exists #{t}_words")
    c.execute("CREATE TABLE `#{t}_words` (
      `id` int(11) NOT NULL default '0',
      `normalized` varchar(100) default NULL,
      `first_letter` char(1) default NULL,
      `length` int(11) default NULL,
      `matched_data` text,
      PRIMARY KEY  (`id`),
      KEY `idx_#{t}_words_1` (`first_letter`,`length`)
      ) ENGINE=InnoDB DEFAULT CHARSET=ASCII")

    query = "insert into #{t}_words select distinct nw.id, nw.word, nw.first_letter, nw.length, null from name_word_semantics nws join name_words nw on nw.id=nws.name_word_id join semantic_meanings sm on sm.id = nws.semantic_meaning_id where sm.name='#{t}' order by nw.word"
    puts query
    c.execute query
  end
end
