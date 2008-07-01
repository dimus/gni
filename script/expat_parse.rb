#!/usr/bin/env ruby
require "rubygems"
require "xml/parser"
require "ruby-prof"



f = open("index_fungorum_short.xml")
#f = open("/Users/dimus/workspace/gna-hosting/dev_data/gni_data.xml")
#f = open("SpeciesText.xml")

p = XMLParser.new

RubyProf.start
  p.parse(f) do |e,n,d|
    if e == XMLParser::START_ELEM
      element = e
    end
    if e == XMLParser::CDATA
      data = d
    end  
  end
result = RubyProf.stop 



printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT, 0)
