#basic scenario is loaded for the most spec cases
require File.dirname(__FILE__) + '/scenario_helper'
yml_file =  File.join(RAILS_ROOT, 'scenarios', 'yml' , 'import_scheduler.yml')
import_scheduler = YAML.load(ERB.new(open(yml_file).read).result)

ImportScheduler.truncate
generate_scenario(import_scheduler)
