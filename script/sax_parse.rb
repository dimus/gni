require 'rubygems'
require 'rexml/document' 
require 'rexml/streamlistener'
require 'ruby-prof'
include REXML

class MyListener
  include REXML::StreamListener
  
  def tag_start(*args)
    tag_start = args.map {|x| x.inspect}.join(', ')
  end
  
  def text(data)
    return if data =~ /^\w*$/
    abbrev = data[0..40] + (data.length > 40 ? "..." : "")
    text = abbrev.inspect
  end
end

list=MyListener.new
f = open("/Users/dimus/workspace/gna-hosting/dev_data/gni_data.xml")

RubyProf.start
  Document.parse_stream(f, list)
result = RubyProf.stop 

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT, 0)