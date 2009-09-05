require File.dirname(__FILE__) + '/../spec_helper'
require 'uri'

describe '/name_strings' do
  before :all do
    Scenario.load :application
    Scenario.load :name_string_search
  end
  
  after :all do
    truncate_all_tables
  end

  before(:each) do
    #scenario :basic
    @resp = req( '/name_strings' )
    @resp_xml = req('/name_strings.xml')
  end

  it 'should render' do
    @resp.success?.should be_true
    @resp_xml.success?.should be_true
  end

  it 'should be used as a root path' do
    @resp.body.should == req('/').body
  end

  it 'should have search box' do
    @resp.body.should have_tag('form[method=?]', 'get') do
      #search input
      with_tag('input[name=?]', 'search_term')
      #normal search button
      with_tag('input[name=?]', 'commit')
      with_tag('input[value=?]', 'Search')
      #without logging in -- no Search Mine button
      without_tag('input[value=?]', 'Search Mine')
    end 
  end

  it 'should do search' do
    resp = req( URI.encode '/name_strings?search_term=Higehananomia Kôno 1935')
    resp.body.should include("Higehananomia Kôno 1935")
  end
  
  it 'should do search with wildcard' do
    resp = req( '/name_strings?search_term=adna*' )
    resp.success?.should be_true
    resp.body.should include("Adnaria frondosa")
    resp.body.should include("Adnatosphaeridium tutulosum (Cookson &amp; Eisenack 1960)")
    resp.body.should_not include("Higehananomia palpalis")
  end
  
  it 'should be able to search a name with an apostrophy' do
    resp = req("/name_strings?search_term=O'Connel")
    resp.success?.should be_true
    resp.body.should include("Tauriaptychus crastobalensis (O'Connel )")
  end
  
  it 'should be able to search names with non-ascii characters' do 
    resp = req(URI.encode "/name_strings?search_term=au:Kôno")
    resp.success?.should be_true
    resp.body.should include("Higehananomia palpalis Kono 1935")
  end

  it 'API should return search in xml and json' do
    resp_xml = req( '/name_strings.xml?search_term=adna*' )
    resp_xml.success?.should be_true
    resp_xml.body.should include('<?xml version="1.0"')
    resp_xml.body.should include("Adnaria frondosa")
    resp_xml.body.should include("Adnatosphaeridium tutulosum (Cookson &amp; Eisenack 1960)")
    resp_xml.body.should_not include("Higehananomia palpalis")
    resp_json = req( '/name_strings.json?search_term=adna*' )
    resp_json.success?.should be_true
    resp_json.body.should include("Adnaria frondosa")
    resp_json.body.should include("Adnatosphaeridium tutulosum (Cookson & Eisenack 1960)")
    resp_json.body.should_not include("Higehananomia palpalis")
  end

  it 'should not search 2 or less chars with wildcard' do
    resp = req( '/name_strings?search_term=ad*')
    resp.success?.should be_true
    resp.body.should_not  include("Adnaria frondosa")
    resp.body.should include("should have at leat 3 letters")
  end
  
  it 'should display a name_string page without layout' do
    #individual name strings are only displayed asyncronously by ajax calls, so their repsonse has no layout
    resp = req( '/name_strings/1' )
    resp.success?.should be_true
    resp.body.should include('Adnaria frondosa')
    resp.body.should_not have_tag('body')
  end
  
  it 'API should display a name_string info in xml or json' do
    resp_xml = req( '/name_strings/1.xml' )
    resp_xml.success?.should be_true
    resp_xml = req( '/name_strings/1.xml?all_records=1' )
    resp_xml.success?.should be_true
    resp_xml.body.should include('<?xml version="1.0"')
    resp_xml.body.should include('Adnaria frondosa')
    resp_json = req( '/name_strings/1.json' )
    resp_json.success?.should be_true
    resp_json.body.should include('Adnaria frondosa')
  end
end
