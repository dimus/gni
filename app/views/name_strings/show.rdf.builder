xml = Builder::XmlMarkup.new(:indent => 2)
gni_url = "http://gni.globalnames.org/name_strings/#{@name_string.uuid_hex}"
xml.instruct!
xml.rdf(:RDF,
  "xmlns:rdfs"                    =>  "http://www.w3.org/2000/01/rdf-schema",
  "xmlns:rdf"                     =>  "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "xmlns:owl"                     =>  "http://www.w3.org/2002/07/owl#",
  "xmlns:skos"                    =>  "http://www.w3.org/2004/02/skos/core#",
  "xmlns:dc"                      =>  "http://purl.org/dc/elements/1.1/",
  "xmlns:dwc"                     =>  "http://rs.tdwg.org/dwc/terms/",
  "xmlns:dcterms"                 =>  "http://purl.org/dc/terms/",
  "xmlns:cc"                      =>  "http://creativecommons.org/ns#") do
  
  xml.rdf(:Description, "rdf:about" => gni_url) do
    xml.dcterms(:title, "About: " + @name_string.name)
    # xml.dcterms(:publisher, "rdf:resource" => PUBLISHER_URI)
    # xml.dcterms(:creator, "rdf:resource"   => CREATOR1_URI)
    # xml.dcterms(:creator, "rdf:resource"   => CREATOR2_URI)
    xml.dcterms(:description, "A RDF document describing Global Name Index Name String: #{@name_string.name}")
    xml.dcterms(:identifier, gni_url)
    xml.dwc(:ScientificName, @name_string.name)
    # xml.dcterms(:language, 'en')
    # xml.dcterms(:isPartOf, "rdf:resource" => DATASET_URI )
    xml.dcterms(:modified, @name_string.updated_at.strftime('%Y-%m-%dT%H:%M:%S%z'))
    xml.cc(:license, "rdf:resource" => "http://creativecommons.org/licenses/publicdomain/")
    # xml.cc(:attributionURL, "rdf:resource" => ATTRIBUTION_URL)
    # xml.foaf(:primaryTopic,  "rdf:resource" => @se_uri)
    # xml.foaf(:topic,         "rdf:resource" => @se_url)
    # xml.foaf(:topic,         "rdf:resource" => @se_rdf)
  end


  #   Description rdf:about="http://gni.globalnames.org/lvs/e720aafd-d049-4ad1-b5ce-a9a6d81c60b6.rdf">
  #   <dcterms:title>Lexical Variant $Name</dcterms:title>
  #   <dcterms:publisher rdf:resource="http://rdf.taxonconcept.org/ont/txn_demo.owl#TaxonConceptCommunity"/>
  #   <dcterms:creator rdf:resource="http://rdf.geospecies.org/ont/people.owl#Peter_J_DeVries"/>
  #   <dcterms:description>A RDF document that maps the various concepts identifiers for the species Puma concolor</dcterms:description>
  #   <skos:scopeNote>Provides metadata about this document.</skos:scopeNote>
  #   <dcterms:identifier>http://gni.globalnames.org/lvs/e720aafd-d049-4ad1-b5ce-a9a6d81c60b6.rdf</dcterms:identifier>
  #   <dcterms:language>en</dcterms:language>
  #   <dcterms:isPartOf rdf:resource="http://rdf.taxonconcept.org/ont/void#this"/>
  #   <dcterms:created>2009-11-20T15:56:04-0600</dcterms:created>
  #   <dcterms:modified>2009-01-10T12:18:04-0600</dcterms:modified>
  #   <cc:license rdf:resource="http://creativecommons.org/licenses/publicdomain/"/>
  #   <!-- Foaf Topic's for "http://rdf.taxonconcept.org/ses/v6n7p.rdf" -->
  #   <foaf:primaryTopic rdf:resource="http://gni.globalnames.org/lvs/e720aafd-d049-4ad1-b5ce-a9a6d81c60b6"/>
  # </rdf:Description>

end
