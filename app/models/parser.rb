#require 'rubygems'
require 'biodiversity'
class Parser
  
  def initialize()
    @parser = ScientificNameParser.new
  end
  
  def parse(names)
    parsed_names = []
    if names && !names.strip.blank?
      old_kcode = $KCODE
      $KCODE = 'NONE'
      names = names.split(/\n|\r/)[0..5000]
      names.map {|n| n.strip}.select {|n| !n.blank?}.each do |name|
        parsed_name = @parser.parse(name) 
        unless parsed_name.blank?
          parsed_names << parsed_name.details.merge({:input => name, :parse_succeeded => true, :canonical => parsed_name.canonical, :cleaned => parsed_name.value})
        else
          parsed_names << {:input => name, :parse_succeeded => false}
        end
      end
      $KCODE = old_kcode
    end
    @parsed_names = parsed_names
  end
  
  def parsed_names
    @parsed_names
  end
  
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.parsed_names do
      @parsed_names.each do |pn|
        xml.parsed_name do
          xml.tag!(:verbatim, pn[:input])
          xml.tag!(:parse_succeeded, pn[:parse_succeeded])
          if pn[:parse_succeeded]
            xml.tag!(:canonical, pn[:canonical])
            xml.tag!(:cleaned, pn[:cleaned])
            if pn[:hybrid]
              xml.tag!(:hybrid, "not implemented in xml")
            end
            xml.tag!(:uninomial, pn[:uninomial]) if pn[:uninomial]
            xml.tag!(:genus, pn[:genus]) if pn[:genus]
            xml.tag!(:species, pn[:species]) if pn[:species]
            if pn[:revised_name_authors]
              xml.tag!(:revised_name_authors, "not implemented in xml")
            end
            if pn[:original_revised_name_authors]
              xml.tag!(:original_revised_name_authors, "not implemented in xml")
            end
            if pn[:orig_authors]
              xml.original_authors do
                if pn[:orig_authors][:names]
                  pn[:orig_authors][:names].each do |n|
                    xml.tag!(:author, n)
                  end
                  xml.tag!(:year, pn[:orig_authors][:year]) if pn[:orig_authors][:year]
                end
              end
            end
            if pn[:authors]
              xml.authors do
                if pn[:authors][:names] && pn[:authors][:names].size > 0
                  pn[:authors][:names].each do |n|
                    xml.tag!(:author, n)
                  end
                  xml.tag!(:year, pn[:authors][:year]) if pn[:authors][:year]
                end
              end
            end  
          end
        end
      end
    end
  end
    
private
  
end
