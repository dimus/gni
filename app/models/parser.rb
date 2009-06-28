#require 'rubygems'
require 'biodiversity'
class Parser
  
  def self.json_to_html(json_string)
    obj = JSON.load json_string
    render_html obj
  end
  
  def self.json_to_xml(json_string)
    obj = JSON.load json_string
    GNI::XML::XML_HEAD + "<scientific_name>\n" + traverse(obj,1) + "</scientific_name>\n"
  end
  
  def initialize()
    @parser = ScientificNameParser.new
    @node = nil
  end
  
  def parse_names_list(names, format = 'json')
    parsed_names = []
    if names && !names.strip.blank?
      names = names.split(/\n|\r/)[0..5000]
      names.map {|n| n.strip}.select {|n| !n.blank?}.each do |name|
        parsed_name = @parser.parse(name).to_json 
        parsed_names << parsed_name
      end
    end
    @parsed_names = "[" + parsed_names.join(",\n") + "]"
    if format == 'json'
      return @parsed_names
    elsif format == 'yaml'
      return JSON.load(@parsed_names).to_yaml
    elsif format == 'xml'
      names = JSON.load(@parsed_names)
      xml_string = GNI::XML::XML_HEAD + "<scientific_names>\n"
      names.each do |name|
        xml_string += "  <scientific_name>\n" + Parser.traverse(name,2) + "  </scientific_name>\n"
      end
      xml_string += "</scientific_names>\n"
      return xml_string
    end
  end
  
  def parse(name)
    old_kcode = $KCODE
    $KCODE = 'NONE'
    @node = @parser.parse(name)
    $KODE = old_kcode
    def @node.to_html 
      Parser.json_to_html(self.to_json)
    end
    def @node.to_xml
      Parser.json_to_xml(self.to_json)
    end
    @node
  end
  
  def parsed_names
    @parsed_names
  end
  
private
  def self.traverse(struct, count = 0)
    count += 1
    keys = []
    retValue = ''
    struct.keys.each do |k|
      if struct[k].class == Hash
        retValue += (' ' * count) + '<node>' + "\n"
        retValue += (' ' * (count + 1)) + '<node_key>' + GNI::XML.escape_xml(k) + '</node_key>' + "\n"
        retValue += traverse(struct[k],count)
        retValue += (' ' * count) +  "</node>\n"
      elsif struct[k].class == Array
        retValue += (' ' * count) +  '<node>'+ "\n"
        retValue += (' ' * (count + 1)) + '<node_key>' + GNI::XML.escape_xml(k) + '</node_key>' + "\n"
        vals = []
        struct[k].each do |el|
          if el.class == Hash
             retValue += traverse(el, count)
          else
            vals << el 
          end
        end
        retValue +=  "<node_value>" + vals.map { |val| GNI::XML.escape_xml(val) }.join("</node_value><node_value>") + "</node_value>"
        retValue += (' ' * count) +  "</node>\n"
      else
        retValue += (' ' * (count + 1)) +  '<node>' + "\n" + (' ' * (count + 2)) + '<node_key>' + GNI::XML.escape_xml(k) + ": " + '</node_key>' + '<node_value>' + GNI::XML.escape_xml(struct[k].to_s) + '</node_value>' + "\n" +  (' ' * (count + 1)) + "</node>\n"
      end
      keys << k
    end
    retValue
  end
  
  def self.render_html(struct)
    xml_string = traverse(struct)
    xml_string.gsub!('<node>', '<div class="tree">')
    xml_string.gsub!('</node>', '</div>')
    xml_string.gsub!('<node_key>', '<span class="tree_key">')
    xml_string.gsub!('</node_key>', '</span>')
    xml_string.gsub!('<node_value></node_value>', ', ')
    xml_string.gsub!('<node_value>', '')
    xml_string.gsub!('</node_value>', '')
    xml_string
  end
end
