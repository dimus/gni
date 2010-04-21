require File.dirname(__FILE__) + '/../spec_helper'

describe 'Parser' do
  before :all do
    @parser = Parser.new
  end
  
  it 'should parse a name' do
    r = @parser.parse "Betula verucosa"
    r.should_not be_nil
    r.should == {:scientificName=>{:details=>[{:species=>{:string=>"verucosa"}, :genus=>{:string=>"Betula"}}], :parser_run=>1, :parsed=>true, :positions=>{0=>["genus", 6], 7=>["species", 15]}, :verbatim=>"Betula verucosa", :canonical=>"Betula verucosa", :hybrid=>false, :normalized=>"Betula verucosa"}}
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
    JSON.load(r).should == [{"scientificName"=>{"canonical"=>"Betula verucosa", "positions"=>{"7"=>["species", 15], "0"=>["genus", 6]}, "verbatim"=>"Betula verucosa", "details"=>[{"genus"=>{"string"=>"Betula"}, "species"=>{"string"=>"verucosa"}}], "parser_run"=>1, "normalized"=>"Betula verucosa", "hybrid"=>false, "parsed"=>true}}, {"scientificName"=>{"canonical"=>"Homo sapiens", "positions"=>{"0"=>["genus", 4], "5"=>["species", 12]}, "verbatim"=>"Homo sapiens", "details"=>[{"genus"=>{"string"=>"Homo"}, "species"=>{"string"=>"sapiens"}}], "parser_run"=>1, "normalized"=>"Homo sapiens", "hybrid"=>false, "parsed"=>true}}]
    r = @parser.parse_names_list("Betula verucosa\nHomo sapiens",'xml')
    r.should include('xml version')
    r = @parser.parse_names_list("Betula verucosa\nHomo sapiens",'yaml')
    r.should include("canonical: Betula verucosa")
  end
end
