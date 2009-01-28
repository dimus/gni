require 'rubygems'
require 'hpricot'
require 'open-uri'

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

  
end


