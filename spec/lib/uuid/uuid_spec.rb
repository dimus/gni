require File.dirname(__FILE__) + '/../../spec_helper'

describe GNI::UUID do
  describe '#v5' do
    it 'should return nil for invalid namespace uuid' do
      GNI::UUID.v5('wrong_namespace_uuid','string').should be_nil
    end

    it 'should return correct uuid for dns hash' do
      GNI::UUID.v5("1546058f-5a25-4334-85ae-e68f2a44bbaf", 'globalnames.org').should == ''
    end

  end

  describe '#valid?' do
    it 'should not validate wrong id' do
      GNI::UUID.valid?('wrong').should be_false
    end

    it 'should validate right id' do
      GNI::UUID.valid?("1546058f-5a25-4334-85ae-e68f2a44bbaf").should be_true
    end
  end
end
