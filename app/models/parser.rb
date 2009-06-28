#require 'rubygems'
require 'biodiversity'
class Parser
  
  def self.json_to_html(json_string)
    obj = JSON.load json_string
    render_html obj
  end
  
  def self.json_to_xml(json_string)
    obj = JSON.load json_string
    render_xml obj
  end
  
  def initialize()
    @parser = ScientificNameParser.new
    @node = nil
  end
  
  def parse_names_list_to_json(names)
    parsed_names = []
    if names && !names.strip.blank?
      names = names.split(/\n|\r/)[0..5000]
      names.map {|n| n.strip}.select {|n| !n.blank?}.each do |name|
        parsed_name = @parser.parse(name).to_json 
        parsed_names << parsed_name
      end
    end
    @parsed_names = "[" + parsed_names.join(",\n") + "]"
  end
  
  def parse(name)
    old_kcode = $KCODE
    $KCODE = 'NONE'
    @node = @parser.parse(name)
    $KODE = old_kcode
    def @node.to_html 
      Parser.json_to_html(self.to_json)
    end
    @node
  end
  
  def parsed_names
    @parsed_names
  end
  
private
  def self.render_html(struct,count = 0)
    count += 1
    keys = []
    retValue = ''
    struct.keys.each do |k|
      if struct[k].class == Hash
        retValue += (' ' * count) + '<div class="tree">' + "\n"
        retValue += (' ' * (count + 1)) + '<span class="tree_key">' + k + '</span>' + "\n"
        retValue += render_html(struct[k],count)
        retValue += (' ' * count) +  "</div>\n"
      elsif struct[k].class == Array
        retValue += (' ' * count) +  '<div class="tree">'+ "\n"
        retValue += (' ' * (count + 1)) + '<span class="tree_key">' + k + '</span>' + "\n"
        vals = []
        struct[k].each do |el|
          # if el.class == Hash
          #   retValue += (' ' * count) +  '<div class="tree">' + "\n"
          #   retValue += (' ' * (count + 1)) + '<span class="tree_key">' + k + '</span>' + "\n"
          #   retValue += render_html(el, count)
          #   retValue += (' ' * count) +  "</div>\n"
          # else
            vals << el 
          # end
          #retValue += vals.join(", ") if vals.size > 0
        end
        retValue +=  vals.join(", ")
        retValue += (' ' * count) +  "</div>\n"
      else
        retValue += (' ' * (count + 1)) +  '<div class="tree">' + "\n" + (' ' * (count + 2)) + '<span class="tree_key">' + k + ": " + '</span>' + struct[k].to_s + "\n" +  (' ' * (count + 1)) + "</div>\n"
      end
      keys << k
    end
    retValue
  end
end
