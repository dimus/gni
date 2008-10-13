require 'rubygems'
require 'date'
require 'spec'
require 'treetop'
require 'node_classes'

Treetop.load('scientific_name')

describe ScientificName do
  before(:all) do
    @parser = ScientificNameParser.new 
    @name = "Pseudocercospora dendrobii (H.C. Burnett) U. Braun & Crous 2003"
  end
  
  def parse(input)
    @parser.parse(input)
  end
  
  def value(input)
    parse(input).value
  end
  
  it 'should parse taxon' do
    parse('Pseudocercospora').should_not be_nil
    value('Pseudocercospora').should == 'Pseudocercospora'
  end
  
  it 'should parse canonical' do
    parse('Pseudocercospora dendrobii').should_not be_nil
    value('   Pseudocercospora        dendrobii  ').should == 'Pseudocercospora dendrobii'
  end
  
  it 'should parse scientific name' do
    parse("Pseudocercospora dendrobii (H.C. Burnett) U. Braun & Crous 2003").should_not be_nil
    value("Pseudocercospora dendrobii(H.C.     Burnett)U. Braun & Crous     2003").should == "Pseudocercospora dendrobii (H.C. Burnett) U. Braun & Crous 2003"
  end
  
  it 'should parse utf-8 name' do
    parse("Trematosphaeria phaeospora (E. Müll.) L. Holm 1957").should_not be_nil
    value("Trematosphaeria         phaeospora (  E.      Müll.       )L.       Holm     1957").should == "Trematosphaeria phaeospora (E. Müll.) L. Holm 1957"
  end
  
  it "should parse name with f." do
    parse("Sphaerotheca fuliginea f. dahliae Movss. 1967").should_not be_nil
    value("   Sphaerotheca    fuliginea     f.    dahliae    Movss.   1967    ").should == "Sphaerotheca fuliginea f. dahliae Movss. 1967"
  end
  
  it "should parse name with var." do
    parse("Phaeographis inusta var. macularis (Leight.) A.L. Sm. 1861").should_not be_nil
    value("Phaeographis     inusta    var. macularis(Leight.)  A.L.       Sm.     1861").should == "Phaeographis inusta var. macularis (Leight.) A.L. Sm. 1861"
  end
  
  it "should parse name without a year but with authors" do 
    parse("Arthopyrenia hyalospora (Nyl.) R.C. Harris").should_not be_nil
  end
  
end
