require File.dirname(__FILE__) + '/../../spec_helper'

describe 'GNI::NameWordsGenerator' do
  before(:all) do
    Scenario.load :application
    @nwp = GNI::NameWordsGenerator.new
  end

  it 'should find words that are not in the system' do    
    @nwp.names.num_rows.should > 1
  end
  
  it 'should have semantics hash' do
    @nwp.semantics.should == {:infraspecies=>4, :uninomial=>1, :species=>3, :genus=>2, :year=>6, :author_word=>5}
  end
  
  it 'should create new words' do
    NameWord.truncate
    NameWordSemantic.truncate
    NameWord.all.should be_blank
    @nwp.generate_words
    NameWord.count.should > 1
    NameWordSemantic.count.should > 1
  end

end