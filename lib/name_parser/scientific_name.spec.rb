require 'rubygems'
require 'date'
require 'spec'
require 'treetop'
require 'node_classes'

Treetop.load('scientific_name')

describe ScientificName do
  before(:all) do
    @parser = ScientificNameParser.new 
  end
  
  def parse(input)
    @parser.parse(input)
  end
  
  def value(input)
    parse(input).value
  end
  
  def canonical(input)
    parse(input).canonical
  end
  
  def details(input)
    parse(input).details
  end
  
  it 'should parse taxon' do
    parse('Pseudocercospora').should_not be_nil
    value('Pseudocercospora').should == 'Pseudocercospora'
    canonical('Pseudocercospora').should == 'Pseudocercospora'
    details('Pseudocercospora').should == {:uninomial=>"Pseudocercospora", :name_type=>"Uninomial"}
  end
  
  it 'should parse canonical' do
    parse('Pseudocercospora dendrobii').should_not be_nil
    value('   Pseudocercospora        dendrobii  ').should == 'Pseudocercospora dendrobii'
    canonical("   Pseudocercospora        dendrobii  ").should == 'Pseudocercospora dendrobii'
    details('Pseudocercospora dendrobii').should == {:species=>"dendrobii", :genus=>"Pseudocercospora"}
  end
  
  it 'should parse subgenus ZOOLOGICAL' do
    parse("Doriteuthis (Amerigo) pealeii Author 1999").should_not be_nil
    value("Doriteuthis(Amerigo    ) pealeii Author 1999").should == "Doriteuthis (Amerigo) pealeii Author 1999"
    canonical("Doriteuthis(Amerigo    ) pealeii Author 1999").should == "Doriteuthis pealeii"
    details("Doriteuthis(Amerigo    ) pealeii Author 1999").should == {:subgenus=>"Amerigo", :authors=>{:year=>"1999", :names=>["Author"]}, :species=>"pealeii", :genus=>"Doriteuthis"}
  end
  
  it 'should parse species autonym for complex subspecies authorships' do
    #parse("Aus bus Linn. var. bus").should_not be_nil
    # aus genus, bus species, Linn. author, var. rank, but infraspecific epithet 
  end
  
  it 'should parse several authors' do
    parse("Pseudocercospora dendrobii U. Braun & Crous").should_not be_nil
    value("Pseudocercospora dendrobii U. Braun & Crous").should == "Pseudocercospora dendrobii U. Braun & Crous"
    canonical("Pseudocercospora dendrobii U. Braun & Crous").should == "Pseudocercospora dendrobii"
    details("Pseudocercospora dendrobii U. Braun & Crous").should == {
        :authors=>{:names=>["U. Braun","Crous"]},
        :species=>"dendrobii", 
        :genus=>"Pseudocercospora"}
  end

  it 'should parse several authors with a year' do
    parse("Pseudocercospora dendrobii U. Braun & Crous 2003").should_not be_nil
    value("Pseudocercospora dendrobii U. Braun & Crous 2003").should == "Pseudocercospora dendrobii U. Braun & Crous 2003"
    canonical("Pseudocercospora dendrobii U. Braun & Crous").should == "Pseudocercospora dendrobii"
    details("Pseudocercospora dendrobii U. Braun & Crous 2003").should == {
        :authors=>{:names=>["U. Braun","Crous"], :year => "2003"},
        :species=>"dendrobii", 
        :genus=>"Pseudocercospora"}
  end  
  
  it 'should parse scientific name' do
    parse("Pseudocercospora dendrobii (H.C. Burnett) U. Braun & Crous 2003").should_not be_nil
    value("Pseudocercospora dendrobii(H.C.     Burnett)U. Braun & Crous     2003").should == "Pseudocercospora dendrobii (H.C. Burnett) U. Braun & Crous 2003"
    canonical("Pseudocercospora dendrobii(H.C.     Burnett)U. Braun & Crous     2003").should == "Pseudocercospora dendrobii"
    details("Pseudocercospora dendrobii(H.C.     Burnett)U. Braun & Crous     2003").should == {
    :authors=>{:year=>"2003",   
      :names=>["U. Braun", "Crous"]
    }, 
    :species=>"dendrobii", 
    :genus=>"Pseudocercospora", 
    :orig_authors=>[{:names=>["H.C. Burnett"]}]}
  
    parse("Stagonospora polyspora M.T. Lucas & Sousa da Câmara 1934").should_not be_nil
    value("Stagonospora polyspora M.T. Lucas & Sousa da Câmara 1934").should == "Stagonospora polyspora M.T. Lucas & Sousa da Câmara 1934"
    details("Stagonospora polyspora M.T. Lucas & Sousa da Câmara 1934").should == {:authors=>{:year=>"1934", :names=>["M.T. Lucas", "Sousa da C\303\242mara"]}, :species=>"polyspora", :genus=>"Stagonospora"}
    
    parse("Cladoniicola staurospora Diederich, van den Boom & Aptroot 2001").should_not be_nil
    parse("Yarrowia lipolytica var. lipolytica (Wick., Kurtzman & E.A. Herrm.) Van der Walt & Arx 1981").should_not be_nil
    parse("Physalospora rubiginosa (Fr.) anon.").should_not be_nil
    parse("Saccharomyces drosophilae anon.").should_not be_nil
  end
  
  
  it 'should parse several authors with several years' do
    parse("Pseudocercospora dendrobii (H.C. Burnett 1883) U. Braun & Crous 2003").should_not be_nil
    value("Pseudocercospora dendrobii(H.C.     Burnett1883)U. Braun & Crous     2003").should == "Pseudocercospora dendrobii (H.C. Burnett 1883) U. Braun & Crous 2003"
    canonical("Pseudocercospora dendrobii(H.C.     Burnett 1883)U. Braun & Crous     2003").should == "Pseudocercospora dendrobii"
    details("Pseudocercospora dendrobii(H.C.     Burnett 1883)U. Braun & Crous     2003").should == {
      :authors=>{
        :year=>"2003", 
        :names=>["U. Braun", "Crous"]
      }, 
      :species=>"dendrobii", 
      :genus=>"Pseudocercospora", 
      :orig_authors=>[{:year=>"1883", :names=>["H.C. Burnett"]}]}
  end

  it 'should parse serveral authors groups with several years NOT BOTANICAL' do
    parse("Pseudocercospora dendrobii (H.C. Burnett 1883) (Leight.) (Movss. 1967) U. Braun & Crous 2003").should_not be_nil
    value("Pseudocercospora dendrobii(H.C.     Burnett1883)(Leight.)(Movss. 1967)U. Braun & Crous     2003").should == "Pseudocercospora dendrobii (H.C. Burnett 1883) (Leight.) (Movss. 1967) U. Braun & Crous 2003"
    canonical("Pseudocercospora dendrobii(H.C.     Burnett 1883)(Leight.)(Movss. 1967)U. Braun & Crous     2003").should == "Pseudocercospora dendrobii"
    details("Pseudocercospora dendrobii(H.C.     Burnett 1883)(Leight.)(Movss. 1967)U. Braun & Crous     2003").should == {:authors=>{:year=>"2003", :names=>["U. Braun", "Crous"]}, :species=>"dendrobii", :genus=>"Pseudocercospora", :orig_authors=>[{:year=>"1883", :names=>["H.C. Burnett"]}, {:names=>["Leight."]}, {:year=>"1967", :names=>["Movss."]}]}

  end

    
  it 'should parse utf-8 name' do
    parse("Trematosphaeria phaeospora (E. Müll.) L. Holm 1957").should_not be_nil
    value("Trematosphaeria         phaeospora (  E.      Müll.       )L.       Holm     1957").should == "Trematosphaeria phaeospora (E. Müll.) L. Holm 1957"
    canonical("Trematosphaeria phaeospora(E. Müll.) L.       Holm 1957").should == "Trematosphaeria phaeospora"
    details("Trematosphaeria phaeospora(E. Müll.) L.       Holm 1957 ").should ==  {:authors=>{:year=>"1957", :names=>["L. Holm"]}, :species=>"phaeospora", :genus=>"Trematosphaeria", :orig_authors=>[{:names=>["E. M\303\274ll."]}]}
  end
  
  it "should parse name with f." do
    
    parse("Sphaerotheca fuliginea f. dahliae Movss. 1967").should_not be_nil
    value("   Sphaerotheca    fuliginea     f.    dahliae    Movss.   1967    ").should == "Sphaerotheca fuliginea f. dahliae Movss. 1967"
    canonical("Sphaerotheca fuliginea f. dahliae Movss. 1967").should == "Sphaerotheca fuliginea dahliae"
    details("Sphaerotheca fuliginea f. dahliae Movss. 1967").should ==  {:subspecies=>[{:type=>"f.", :value=>"dahliae"}], :authors=>{:year=>"1967", :names=>["Movss."]}, :species=>"fuliginea", :genus=>"Sphaerotheca"}
  end
  
  it "should parse name with var." do
    parse("Phaeographis inusta var. macularis (Leight.) A.L. Sm. 1861").should_not be_nil
    value("Phaeographis     inusta    var. macularis(Leight.)  A.L.       Sm.     1861").should == "Phaeographis inusta var. macularis (Leight.) A.L. Sm. 1861"
    canonical("Phaeographis     inusta    var. macularis(Leight.)  A.L.       Sm.     1861").should == "Phaeographis inusta macularis"
  end
  
  it "should parse name with several subspecies names" do
    parse("Hydnellum scrobiculatum var. zonatum f. parvum (Banker) D. Hall & D.E. Stuntz 1972").should_not be_nil
    value("Hydnellum scrobiculatum var. zonatum f. parvum (Banker) D. Hall & D.E. Stuntz 1972").should == "Hydnellum scrobiculatum var. zonatum f. parvum (Banker) D. Hall & D.E. Stuntz 1972"
    details("Hydnellum scrobiculatum var. zonatum f. parvum (Banker) D. Hall & D.E. Stuntz 1972").should == {:subspecies=>[{:type=>"var.", :value=>"zonatum"}, {:type=>"f.", :value=>"parvum"}], :authors=>{:year=>"1972", :names=>["D. Hall", "D.E. Stuntz"]}, :species=>"scrobiculatum", :genus=>"Hydnellum", :orig_authors=>[{:names=>["Banker"]}]}
  end
  
  it "should parse status" do
    #it is always latin abbrev often 2 words
    parse("Arthopyrenia hyalospora (Nyl.) R.C. Harris comb. nov.").should_not be_nil
    value("Arthopyrenia hyalospora (Nyl.) R.C. Harris comb. nov.").should == "Arthopyrenia hyalospora (Nyl.) R.C. Harris comb. nov."
    canonical("Arthopyrenia hyalospora (Nyl.) R.C. Harris comb. nov.").should == "Arthopyrenia hyalospora"
    details("Arthopyrenia hyalospora (Nyl.) R.C. Harris comb. nov.").should == {:status=>"comb. nov.", :orig_authors=>[{:names=>["Nyl."]}], :species=>"hyalospora", :authors=>{:names=>["R.C. Harris"]}, :genus=>"Arthopyrenia"}
  end
  
  it "should parse name without a year but with authors" do 
    parse("Arthopyrenia hyalospora (Nyl.) R.C. Harris").should_not be_nil
    value("Arthopyrenia hyalospora(Nyl.)R.C.     Harris").should == "Arthopyrenia hyalospora (Nyl.) R.C. Harris"
    canonical("Arthopyrenia hyalospora (Nyl.) R.C. Harris").should == "Arthopyrenia hyalospora"
  end
  
  it "should parse revised (ex) names" do
    #invalidly published
    parse("Arthopyrenia hyalospora (Nyl. ex Banker) R.C. Harris").should_not be_nil
    value("Arthopyrenia hyalospora (Nyl. ex Banker) R.C. Harris").should == "Arthopyrenia hyalospora (Nyl. ex Banker) R.C. Harris"
    canonical("Arthopyrenia hyalospora (Nyl. ex Banker) R.C. Harris").should == "Arthopyrenia hyalospora"
    details("Arthopyrenia hyalospora (Nyl. ex Banker) R.C. Harris").should == {:original_revised_name_authors=>{:revised_authors=>{:names=>["Nyl."]}, :authors=>{:names=>["Banker"]}}, :authors=>{:names=>["R.C. Harris"]}, :species=>"hyalospora", :genus=>"Arthopyrenia"}
    
    parse("Arthopyrenia hyalospora Nyl. ex Banker").should_not be_nil
    
    parse("Glomopsis lonicerae Peck ex C.J. Gould 1945").should_not be_nil
    details("Glomopsis lonicerae Peck ex C.J. Gould 1945").should == {:revised_name_authors=>{:authors=>{:year=>"1945", :names=>["C.J. Gould"]}, :revised_authors=>{:names=>["Peck"]}}, :species=>"lonicerae", :genus=>"Glomopsis"}
  
    parse("Acanthobasidium delicatum (Wakef.) Oberw. ex Jülich 1979").should_not be_nil
  
  end
  
  it "should parse multiplication sign" do
    #parse("Arthopyrenia x hyalospora (Nyl.) R.C. Harris").should_not be_nil
    #details("Arthopyrenia x hyalospora (Nyl.) R.C. Harris").should == {}
    #Arthopyrenia X hyalospora(Nyl. ex Banker) R.C. Harris
    #X Arthopyrenia (Nyl. ex Banker) R.C. Harris
    #x Arthopyrenia hyalospora (Nyl. ex Banker) R.C. Harris
  end
  
  it "should parse hybrid formula" do
    parse("Arthopyrenia hyalospora X Hydnellum scrobiculatum").should_not be_nil
    value("Arthopyrenia hyalospora X Hydnellum scrobiculatum").should == "Arthopyrenia hyalospora x Hydnellum scrobiculatum"
    canonical("Arthopyrenia hyalospora X Hydnellum scrobiculatum").should == "Arthopyrenia hyalospora x Hydnellum scrobiculatum"
    details("Arthopyrenia hyalospora x Hydnellum scrobiculatum").should == {:hybrid=>{:scientific_name1=>{:species=>"hyalospora", :genus=>"Arthopyrenia"}, :scientific_name2=>{:species=>"scrobiculatum", :genus=>"Hydnellum"}}}
    
    parse("Arthopyrenia hyalospora (Banker) D. Hall x Hydnellum scrobiculatum D.E. Stuntz").should_not be_nil
    value("Arthopyrenia hyalospora (Banker) D. Hall X Hydnellum scrobiculatum D.E. Stuntz").should == "Arthopyrenia hyalospora (Banker) D. Hall x Hydnellum scrobiculatum D.E. Stuntz"
    canonical("Arthopyrenia hyalospora (Banker) D. Hall X Hydnellum scrobiculatum D.E. Stuntz").should == "Arthopyrenia hyalospora x Hydnellum scrobiculatum"
    
    parse("Arthopyrenia hyalospora x").should_not be_nil
    value("Arthopyrenia hyalospora X").should == "Arthopyrenia hyalospora x ?"  
    canonical("Arthopyrenia hyalospora x").should == "Arthopyrenia hyalospora x ?"
    details("Arthopyrenia hyalospora x").should == {:hybrid=>{:scientific_name1=>{:species=>"hyalospora", :genus=>"Arthopyrenia"}, :scientific_name2=>"?"}}  
    parse("Arthopyrenia hyalospora x ?").should_not be_nil
    details("Arthopyrenia hyalospora x ?").should == {:hybrid=>{:scientific_name1=>{:species=>"hyalospora", :genus=>"Arthopyrenia"}, :scientific_name2=>"?"}}
  end

  

  it "should parse name with subspecies without rank selector NOT BOTANICAL" do
    name = "Hydnellum scrobiculatum zonatum (Banker) D. Hall & D.E. Stuntz 1972"
    parse(name).should_not be_nil
    value(name).should == "Hydnellum scrobiculatum zonatum (Banker) D. Hall & D.E. Stuntz 1972"
    canonical(name).should == "Hydnellum scrobiculatum zonatum"
    details(name).should == {:subspecies=>{:type=>"n/a", :value=>"zonatum"}, :authors=>{:year=>"1972", :names=>["D. Hall", "D.E. Stuntz"]}, :species=>"scrobiculatum", :genus=>"Hydnellum", :orig_authors=>[{:names=>["Banker"]}]}
  end
  
  it "should not parse utf-8 chars in name part" do
    parse("Érematosphaeria phaespora").should be_nil
    parse("Trematosphaeria phaeáapora").should be_nil
  end
  
end
