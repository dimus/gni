#!/usr/bin/env ruby

module NameParser

 def self.parse(name)
   return []
 end

end


describe NameParser do

 
  it "should parse 'Puma concolor L.'" do
    p = NameParser::parse('Puma concolor L.')
    p.shoud be_an_instance_of Array
  end

end

