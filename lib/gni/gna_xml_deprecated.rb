require 'rubygems'
require 'open-uri'
require 'json'
require 'digest/sha1'

module GNA_XML

  def self.xml_escape(input)
    result = input.dup.strip

    result.gsub!(/[&<>'"\v]/) do | match |
        case match
        when '&' then '&amp;'
        when '<' then '&lt;'
        when '>' then '&gt;'
        when "'" then '&apos;'
        when '"' then '&quot;'
        end
    end
    result.gsub!(/\v/, " ")
    result.gsub(/\s{2,}/," ")
  end

  #takes parameters created from tcs imput and converts them into gni params
  def self.from_tcs(params)
    data = {} 
    data_source_title = params[:DataSet][:MetaData][:Simple] || '' rescue ''
    data_source = DataSource.find_by_title(data_source_title)
    return "Cannot find Repository with the name #{data_source_title}" unless data_source
    data[:data_source_id] = data_source.id
    data[:name_index_records] = []
    taxon_names = params[:DataSet][:TaxonNames][:TaxonName]
    if taxon_names.class.name == 'Array'
      taxon_names.each do |taxon_name|
        data[:name_index_records] << self.convert_taxon_name(taxon_name, data_source.id)
      end
    else
      data[:name_index_records] << self.convert_taxon_name(taxon_names, data_source.id)
    end
    data
  end

  def self.to_tcs(name_index_records, other_data = nil)
    tcs = '<?xml version="1.0" encoding="utf-8"?>
<DataSet
  xmlns="http://gnapartnership.org/schemas/tcs/1.01"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dwc="http://rs.tdwg.org/dwc/dwcore/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:gn="http://gnapartnership.org/schemas/0_1"
  xsi:schemaLocation="http://gnapartnership.org/schemas/tcs/1.01 http://gnapartnership.org/gna_tcs/tcs_gni_v_0_1.xsd">
'
    if other_data
      tcs += "<TotalItems>#{other_data[:total_items]}</TotalItems>" if other_data[:total_items]
      tcs += "<TotalPages>#{other_data[:total_pages]}</TotalPages>" if other_data[:total_pages]
      tcs += "<PageNumber>#{other_data[:page_number]}</PageNumber>" if other_data[:page_number]
      tcs += "<ItemsPerPage>#{other_data[:per_page]}</ItemsPerPage>" if other_data[:per_page]
    end
    tcs += "  <TaxonNames>\n"
    count = 0
    name_index_records.each  do |r|
      count += 1
      tcs += "    <TaxonName id=\"#{count}\">"
      #name normally is not part of the system
      tcs += "      <Simple>#{self.xml_escape(r.name)}</Simple>"
      tcs += "      <Rank>#{self.xml_escape(r.rank)}</Rank>" if r.rank
      tcs += "      <ProviderSpecificData>"
      tcs += "        <dc:Kingdom>#{self.xml_escape(r.kingdom.name)}</dc:Kingdom>" if r.kingdom
      tcs += "        <dc:identifier>#{r.local_id}</dc:identifier>" if r.local_id
      tcs += "        <dwc:GlobalUniqueIdentifier>#{self.xml_escape(r.global_id)}</dwc:GlobalUniqueIdentifier>" if r.global_id
      tcs += "      </ProviderSpecificData>"
      tcs += "    </TaxonName>"
    end
    tcs += '
  </TaxonNames>
</DataSet>'
  end

protected
  def self.convert_taxon_name(taxon_name, data_source_id)
    res = {}
    #create hash from the available data. Hash is used to find out if data were updated
    data = {}
    data['Simple'] = taxon_name[:Simple] if taxon_name[:Simple]
    data['Rank'] = taxon_name[:Rank] if taxon_name[:Rank]
    data['source'] = taxon_name[:ProviderSpecificData][:source] if taxon_name[:ProviderSpecificData][:source]
    data['GlobalUniqueIdentifier'] = taxon_name[:ProviderSpecificData][:GlobalUniqueIdentifier] if taxon_name[:ProviderSpecificData][:GlobalUniqueIdentifier]
    data['identifier'] = taxon_name[:ProviderSpecificData][:identifier] if taxon_name[:ProviderSpecificData][:identifier]
    data['Kingdom'] = taxon_name[:ProviderSpecificData][:Kingdom] if taxon_name[:ProviderSpecificData][:Kingdom]
    data['data_source_id'] = data_source_id
    keys = data.keys.sort
    res[:hash_string] = keys.map {|k| data[k]}.to_json.gsub(' ', '')
    puts res[:hash_string]    
    res[:hash] = Digest::SHA1.hexdigest(res[:hash_string])
    res[:local_id] = data['identifier'] 
    res[:url] = data['source']
    res[:guid] = data['GlobalUniqueIdentifier']
    res[:rank] = data['Rank']
    res[:kingdom] = data['Kingdom']
    res
  end
  
  
  class TcsXmlBuilder
    
    def initialize(data_source)
      @data_source = data_source
      @tcs_file = open @data_source.directory_path + '/' + @data_source.id.to_s, 'w'
      @tcs_file.write('<?xml version="1.0" encoding="utf-8"?>
  <DataSet
    xmlns="http://gnapartnership.org/schemas/tcs/1.01"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dwc="http://rs.tdwg.org/dwc/dwcore/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:gn="http://gnapartnership.org/schemas/0_1"
    xsi:schemaLocation="http://gnapartnership.org/schemas/tcs/1.01 http://gnapartnership.org/gna_tcs/tcs_gni_v_0_1.xsd">
    <TaxonNames>')
    end
    
    def make_node(record_data, count)
      record = [""]
      record << (" " * 4) + "<TaxonName id=\"#{count}\" nomenclaturalCode=\"#{record_data['dwc:NomenclaturalCode'] || "Indeterminate"}\">"
      record << (" " * 6) + "<Simple>#{GNA_XML.xml_escape(record_data['dwc:ScientificName'])}</Simple>"
      record << (" " * 6) + "<Rank>#{GNA_XML.xml_escape(record_data['dwc:TaxonRank'])}</Rank>" if record_data.key? 'dwc:TaxonRank'
      record << (" " * 6) + "<ProviderSpecificData>"
      record << (" " * 8) +  "<dwc:Kingdom>#{GNA_XML.xml_escape(record_data['dwc:Kingdom'])}</dwc:Kingdom>" if record_data.key? 'dwc:Kingdom'
      record << (" " * 8) + "<dc:identifier>#{GNA_XML.xml_escape(record_data['dc:identifier'])}</dc:identifier>" if record_data.key? 'dc:identifier'
      record << (" " * 8) + "<dc:source>#{GNA_XML.xml_escape(record_data['dc:source'])}</dc:source>" if record_data.key? 'dc:source'
      record << (" " * 8) + "<dwc:GlobalUniqueIdentifier>#{GNA_XML.xml_escape(record_data['dwc:GlobalUniqueIdentifier'])}</dwc:GlobalUniqueIdentifier>" if record_data.key? 'dwc:GlobalUniqueIdentifier'
      record << (" " * 6) + "</ProviderSpecificData>"
      record << (" " * 4) + "</TaxonName>"
      @tcs_file.write(record.join("\n"))
      puts count if count % 100000 == 0
    end
    
    def close
      @tcs_file.write("\n </TaxonNames>\n</DataSet>\n")
      @tcs_file.close
    end
  end
end


