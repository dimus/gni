require File.dirname(__FILE__) + '/../spec_helper'

describe Parser do
  before :all do
    @parser = Parser.new
  end
  
  it 'should parse a name' do
    r = @parser.parse "Betula verucosa"
    r.should_not be_nil
    JSON.load(r.to_json).should == {"scientificName"=>{"canonical"=>"Betula verucosa", "details"=>[{"genus"=>{"epitheton"=>"Betula"}, "species"=>{"epitheton"=>"verucosa"}}], "verbatim"=>"Betula verucosa", "normalized"=>"Betula verucosa", "hybrid"=>false, "parsed"=>true}}
  end
  
  it 'should returnd parsed false for names it cannot parse' do
    r = @parser.parse "this is a bad name"
    r.should_not be_nil
    JSON.load(r.to_json).should == JSON.load('{"scientificName":{"verbatim":"this is a bad name", "parsed":false}}')
  end
  
  it 'should convert parsed result to html' do
    r = @parser.parse "Betula verucosa"
    r.to_html.should == " <div class=\"tree\">\n  <span class=\"tree_key\">scientificName</span>\n   <div class=\"tree\">\n    <span class=\"tree_key\">canonical: </span>Betula verucosa\n   </div>\n  <div class=\"tree\">\n   <span class=\"tree_key\">details</span>\n   <div class=\"tree\">\n    <span class=\"tree_key\">genus</span>\n     <div class=\"tree\">\n      <span class=\"tree_key\">epitheton: </span>Betula\n     </div>\n   </div>\n   <div class=\"tree\">\n    <span class=\"tree_key\">species</span>\n     <div class=\"tree\">\n      <span class=\"tree_key\">epitheton: </span>verucosa\n     </div>\n   </div>\n  </div>\n   <div class=\"tree\">\n    <span class=\"tree_key\">verbatim: </span>Betula verucosa\n   </div>\n   <div class=\"tree\">\n    <span class=\"tree_key\">normalized: </span>Betula verucosa\n   </div>\n   <div class=\"tree\">\n    <span class=\"tree_key\">hybrid: </span>false\n   </div>\n   <div class=\"tree\">\n    <span class=\"tree_key\">parsed: </span>true\n   </div>\n </div>\n"
  end
  
  
  it 'should parse names_list' do
    r = @parser.parse_names_list("Betula verucosa\nHomo sapiens")
    JSON.load(r).should == [{"scientificName"=>{"canonical"=>"Betula verucosa", "details"=>[{"genus"=>{"epitheton"=>"Betula"}, "species"=>{"epitheton"=>"verucosa"}}], "verbatim"=>"Betula verucosa", "normalized"=>"Betula verucosa", "hybrid"=>false, "parsed"=>true}}, {"scientificName"=>{"canonical"=>"Homo sapiens", "details"=>[{"genus"=>{"epitheton"=>"Homo"}, "species"=>{"epitheton"=>"sapiens"}}], "verbatim"=>"Homo sapiens", "normalized"=>"Homo sapiens", "hybrid"=>false, "parsed"=>true}}]
    r = @parser.parse_names_list("Betula verucosa\nHomo sapiens",'xml')
    r.should include('xml version')
    r = @parser.parse_names_list("Betula verucosa\nHomo sapiens",'yaml')
    r.should include("canonical: Betula verucosa")
  end
end