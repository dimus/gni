#require 'rubygems'
require 'biodiversity'
class Parser
  
  def initialize()
    @parser = ScientificNameParser.new
    @parsed = nil
  end
  
  def parse_names_list(names, format = 'json')
    parsed_names = []
    if names && !names.strip.blank?
      names = names.split(/\n|\r/)[0..5000]
      names.map {|n| n.strip}.select {|n| !n.blank?}.each do |name|
        parsed_name = parse(name)
        parsed_names << parsed_name.format_json
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
    elsif format == 'html'
      names = JSON.load(@parsed_names)
      html_string = ''
      names.each do |name|
        html_string += Parser.render_html(name)
        html_string += "<br/>"
      end
      return html_string
    end
  end
  
  def parse(name, format = nil)
    old_kcode = $KCODE
    $KCODE = 'NONE'
    begin
      result = @parser.parse(name)     
      @parsed = @parser.parsed
    rescue 
      result = {:scientificName => {:verbatim => name, :parsed => false, :error => 'Parser fatal error'}}
      @parsed = nil
    end
    $KCODE = old_kcode
    #add format_json, format_html, format_xml methods to singleton class
    result.extend GNI::ParserResult
    result.parsed = @parsed
    result
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
    xml_string.gsub!('</node_value><node_value>', ', ')
    xml_string.gsub!('<node_value>', '')
    xml_string.gsub!('</node_value>', '')
    xml_string
  end
end
