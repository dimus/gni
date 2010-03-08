require File.dirname(__FILE__) + '/../spec_helper'

describe "/uuids" do
  describe "index" do
    
    before (:all) do
      names = ["Betula verucosa", "Parus major"].join("|")
      names = URI.encode(names)
      @xml_res = request("/uuids.xml?names=#{names}")
      @yaml_res = request("/uuids.yaml?names=#{names}")
      @json_res = request("/uuids.json?names=#{names}&callback=myFunc")
    end

    it "should render" do
      @xml_res.success?.should be_true
      @yaml_res.success?.should be_true
      @json_res.success?.should be_true
    end

    it "should get valid xml" do
      dom = Nokogiri::XML(@xml_res.body)
      dom.xpath("//record[1]/name").text.should == "Betula verucosa"
      dom.xpath("//record[1]/uuid").text.should == "4c19ac07-ec67-5cff-97bf-7d9ecbe12e34"
      dom.xpath("//record").size.should == 2
    end  
    
    it "should render yaml" do
      @yaml_res.body.should include("--")
      @yaml_res.body.should include("Parus major")
      @yaml_res.body.should include("47d61c81-5a0f-5448-964a-34bbfb54ce8b")
    end

    it "should render json" do
      names_json = @json_res.body.match(/\((.*)\)/)[1] 
      res = JSON.load(names_json)
      @json_res.body.match(/^myFunc/).should_not be_nil
      res[0]['name'].should == "Betula verucosa"
    end

    it "should remove double spaces and spaces on edges" do
      name = URI.encode("    Betula         verucosa            ")
      res = request("/uuids.json?names=#{name}")
      res = JSON.load(res.body)
      res[0]["name"].should == "Betula verucosa"
      res[0]["uuid"].should == "4c19ac07-ec67-5cff-97bf-7d9ecbe12e34"
    end

  end
end
