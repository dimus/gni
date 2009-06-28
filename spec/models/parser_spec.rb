require File.dirname(__FILE__) + '/../spec_helper'

describe Parser do
  before :all do
    @parser = Parser.new
  end
  
  it 'should parse a name' do
    r = @parser.parse "Betula verucosa"
    r.should_not be_nil
    JSON.load(r.to_json).should == JSON.load("{\"scientificName\":{\"genus\":{\"epitheton\":\"Betula\"},\"verbatim\":\"Betula verucosa\",\"species\":{\"epitheton\":\"verucosa\"},\"canonical\":\"Betula verucosa\",\"normalized\":\"Betula verucosa\",\"parsed\":true}}")
  end
  
  it 'should returnd parsed false for names it cannot parse' do
    r = @parser.parse "this is a bad name"
    r.should_not be_nil
    JSON.load(r.to_json).should == JSON.load('{"scientificName":{"verbatim":"this is a bad name", "parsed":false}}')
  end
  
  it 'should convert parsed result to html' do
    r = @parser.parse "Betula verucosa"
    r.to_html.should == " <div class=\"tree\">\n  <span class=\"tree_key\">scientificName</span>\n   <div class=\"tree\">\n    <span class=\"tree_key\">canonical: </span>Betula verucosa\n   </div>\n   <div class=\"tree\">\n    <span class=\"tree_key\">verbatim: </span>Betula verucosa\n   </div>\n   <div class=\"tree\">\n    <span class=\"tree_key\">normalized: </span>Betula verucosa\n   </div>\n  <div class=\"tree\">\n   <span class=\"tree_key\">genus</span>\n    <div class=\"tree\">\n     <span class=\"tree_key\">epitheton: </span>Betula\n    </div>\n  </div>\n   <div class=\"tree\">\n    <span class=\"tree_key\">parsed: </span>true\n   </div>\n  <div class=\"tree\">\n   <span class=\"tree_key\">species</span>\n    <div class=\"tree\">\n     <span class=\"tree_key\">epitheton: </span>verucosa\n    </div>\n  </div>\n </div>\n"
  end
  
  it 'should parse names_list' do
    r = @parser.parse_names_list_to_json "Betula verucosa\Homo sapiens"
    JSON.load(r).should == [{"scientificName"=>{"canonical"=>"Betula verucosa sapiens", "verbatim"=>"Betula verucosaHomo sapiens", "normalized"=>"Betula verucosa Homo sapiens", "infraspecies"=>{"epitheton"=>"sapiens", "rank"=>"n/a"}, "genus"=>{"epitheton"=>"Betula"}, "parsed"=>true, "species"=>{"epitheton"=>"verucosa", "basionymAuthorTeam"=>{"authorTeam"=>"Homo", "author"=>["Homo"]}, "authorship"=>"Homo"}}}]
  end
end