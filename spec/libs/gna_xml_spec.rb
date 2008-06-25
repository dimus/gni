require File.dirname(__FILE__) + '/../../lib/gna_xml'

describe GNA_XML do
  
  describe 'GNA_XML::data_source_xml' do
    
    #TODO: add specs for wrong xml files as well.
    
    before(:each) do
      @data_source_xml = File.dirname(__FILE__) + "/../fixtures/feeds/index_fungorum_data_source.xml"
      @res = GNA_XML::data_source_xml(@data_source_xml)
    end
    
    it "should return hash" do
      @res.should be_an_instance_of(Hash)
    end
    
    it 'result should have metadata_url, data_url, title' do
       @res[:metadata_url].should == @data_source_xml
       @res[:title].should == "Index Fungorum"
       @res[:data_url].should == "url_to_data.xml"
       @res[:data_zip_compressed].should == true
    end
    
    
    it 'result might have description, logo_url' do
      @res[:description].should be_an_instance_of(String)
      @res[:logo_url].should be_an_instance_of(String)      
    end
  end
end

