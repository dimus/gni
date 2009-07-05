require File.dirname(__FILE__) + '/../../spec_helper'

describe 'GNI::NameWordsGenerator' do
  before(:all) do
    Scenario.load :application
    @nwp_all = GNI::NameWordsGenerator.new(true)
    @nwp = GNI::NameWordsGenerator.new(true)
  end

  it 'should find words that are not in the system' do    
    @nwp_all.names.num_rows.should > 1
    @nwp.names.num_rows.should > 1
  end
  
  it 'should have semantics hash' do
    @nwp.semantics.should = ''
  end

end