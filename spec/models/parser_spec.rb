require File.dirname(__FILE__) + '/../spec_helper'

describe Parser do
  before :all do
    @parser = Parser.new
  end
  
  
  it 'should parse a name' do
    r = @parser.parse "Betula verucosa\nParus major"
    r.should_not be_nil
    r.size.should == 2
    @parser.to_xml.should include('</parsed_name>')
  end
end