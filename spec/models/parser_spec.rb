require File.dirname(__FILE__) + '/../spec_helper'

describe 'Parser' do
  before :all do
    @parser = Parser.new
  end
  
  it 'should parse a name' do
    r = @parser.parse "Betula verucosa"
    r.should_not be_nil
    r.should ==  {:scientificName=>{:parsed=>true, :verbatim=>"Betula verucosa", :normalized=>"Betula verucosa", :details=>[{:genus=>{:epitheton=>"Betula"}, :species=>{:epitheton=>"verucosa"}}], :hybrid=>false, :canonical=>"Betula verucosa", :positions=>{0=>["genus", 6], 7=>["species", 15]}}}
  end
  
  it 'should returnd parsed false for names it cannot parse' do
    r = @parser.parse "this is a bad name"
    r.should_not be_nil
    r.should == {:scientificName=>{:parsed=>false, :verbatim=>"this is a bad name"}}
  end
  
  it 'should convert parsed result to html' do
    r = @parser.parse "Betula verucosa"
    r.format_html.should include('span class')
  end
  
  it 'should convert parsed result to json' do
    r = @parser.parse "Betula verucosa"
    r.format_json.should include "{\"scientificName\""
  end
  
  it 'should parse names_list' do
    r = @parser.parse_names_list("Betula verucosa\nHomo sapiens")
    JSON.load(r).should == [{"scientificName"=>{"canonical"=>"Betula verucosa", "positions"=>{"7"=>["species", 15], "0"=>["genus", 6]}, "details"=>[{"genus"=>{"epitheton"=>"Betula"}, "species"=>{"epitheton"=>"verucosa"}}], "verbatim"=>"Betula verucosa", "normalized"=>"Betula verucosa", "hybrid"=>false, "parsed"=>true}}, {"scientificName"=>{"canonical"=>"Homo sapiens", "positions"=>{"0"=>["genus", 4], "5"=>["species", 12]}, "details"=>[{"genus"=>{"epitheton"=>"Homo"}, "species"=>{"epitheton"=>"sapiens"}}], "verbatim"=>"Homo sapiens", "normalized"=>"Homo sapiens", "hybrid"=>false, "parsed"=>true}}]
    r = @parser.parse_names_list("Betula verucosa\nHomo sapiens",'xml')
    r.should include('xml version')
    r = @parser.parse_names_list("Betula verucosa\nHomo sapiens",'yaml')
    r.should include("canonical: Betula verucosa")
  end
end