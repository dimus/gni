#require 'rubygems'
require 'biodiversity'
class Parser
  @parser = ScientificNameParser.new
  
  def self.parse(names)
    parsed_names = []
    if names && !names.strip.blank?
      old_kcode = $KCODE
      $KCODE = 'NONE'
      names.split("\n").map {|n| n.strip}.select {|n| !n.blank?}.each do |name|
        parsed_name = @parser.parse(name)
        if parsed_name
          parsed_names << parsed_name.details.merge({:input => name, :parse_succeeded => true, :canonical => parsed_name.canonical, :cleaned => parsed_name.value})
        else
          parsed_names << {:input => name, :parse_succeeded => false}
        end
      end
      $KCODE = old_kcode
    end
    parsed_names
  end
  
end
