#basic scenario is loaded for the most spec cases
require 'rubygems'
require 'biodiversity'
require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/../spec/spec_helper'
require File.dirname(__FILE__) + '/scenario_helper'
yml_file =  File.join(RAILS_ROOT, 'scenarios', 'yml' , 'application.yml')


data = YAML.load(ERB.new(open(yml_file).read).result)

generate_scenario(data)

populate_name_word_semantic_table()


