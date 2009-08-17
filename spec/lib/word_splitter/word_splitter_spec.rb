require File.dirname(__FILE__) + '/../../spec_helper'

describe 'GNI::NameWordsGenerator' do
  before(:all) do
    Scenario.load :application
    10.times {NameString.generate}
    @nwp = GNI::NameWordsGenerator.new
  end
  
  it 'should find words that are not in the system' do    
    @nwp.names.num_rows.should > 1
  end
  
  it 'should have semantics hash' do
    @nwp.semantics.should == {:infraspecies=>4, :uninomial=>1, :species=>3, :genus=>2, :year=>6, :author_word=>5}
  end
  
  it 'should create new words' do
    nwc = NameWord.count
    nwsc = NameWordSemantic.count
    @nwp.generate_words
    NameWord.count.should > nwc
    NameWordSemantic.count.should > nwsc
  end

end