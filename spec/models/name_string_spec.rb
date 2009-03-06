require File.dirname(__FILE__) + '/../spec_helper'

describe NameString do

  #it { should have_one(:kingdom) }
  #it { should have_many(:name_indices) }

  it "should require a valid #string" do
    NameString.gen( :name => 'Plantago' ).should be_valid
    NameString.build( :name => 'Plantago' ).should_not be_valid # because there's already Plantago
  end

end

