#scenario to perform name_string searches
require File.dirname(__FILE__) + '/scenario_helper'
unless defined? RAILS_ROOT
  require File.dirname(__FILE__) + '/../config/environment'
  require File.dirname(__FILE__) + '/../spec/spec_helper'
end
yml_file =  File.join(RAILS_ROOT, 'scenarios', 'yml' , 'name_string_search.yml')
data = YAML.load(ERB.new(open(yml_file).read).result)

NameWord.truncate
NameWordSemantic.truncate
generate_scenario(data)

populate_name_word_semantic_table()