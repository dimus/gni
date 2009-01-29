require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'json'
require 'digest/sha1'

module GNA_XML
  #parsing metadata xml file (deprecated)
  def self.data_source_xml(data_source_url)
    ds = {}
    doc = Hpricot.XML(open(data_source_url))
    ds[:metadata_url] = data_source_url
    ds[:title] = (doc/"dc:title").text
    ds[:description] = (doc/"dc:description").text
    ds[:logo_url] = (doc/"logoURL").text
    ds[:data_zip_compressed] = nil
    durl = (doc/"dataURL")
    zipped = durl.attr "zipCompressed"
    ds[:data_url] = durl.text
    if zipped == "true":
      ds[:data_zip_compressed] = true
    elsif zipped == "false"
      ds[:data_zip_compressed] = false
    else
      throw(printf("wrong data for zip_compressed attribute: '%s'", zipped))
    end
    ds
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
  
end


