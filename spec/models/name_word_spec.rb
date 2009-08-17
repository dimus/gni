require File.dirname(__FILE__) + '/../spec_helper'
describe NameWord do
  it 'should split scientific names into words' do
    NameWord.get_words('Betula verucosa').should == [[0, "BETULA"], [7, "VERUCOSA"]]
    NameWord.get_words('Salmonella werahensis (Castellani) Hauduroy and Ehringer in Hauduroy 1937').should == [[0, "SALMONELLA"], [11, "WERAHENSIS"], [23, "CASTELLANI"], [35, "HAUDUROY"], [48, "EHRINGER"], [57, "IN"], [60, "HAUDUROY"], [69, "1937"]]
  end
end