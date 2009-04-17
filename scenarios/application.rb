#basic scenario is loaded for the most spec cases
require File.dirname(__FILE__) + '/scenario_helper'
yml_file =  File.join(RAILS_ROOT, 'scenarios', 'yml' , 'application.yml')
data = YAML.load(ERB.new(open(yml_file).read).result)

generate_scenario(data)
