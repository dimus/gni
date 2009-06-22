require File.dirname(__FILE__) + '/../spec_helper'

describe 'NameString.normalize_name_string' do
  it "should convert strings to normalized form" do 
    strings = [
      ['Betula','Betula'], #no changes
      # ['Betula Mark&John', 'Betula Mark & John'], #one space before and after ampersand
      #  ['Parus major ( L. )', 'Parus major (L.)'],
      #  ['Parus major [ L . ]', 'Parus major [L.]'],
      #  ['Parus major (    L   .& Murray 188? )', 'Parus major (L. & Murray 188?)'],
      #  ["Plantago\t\t minor L. , Murray&Linn 1733", 'Plantago minor L., Murray & Linn 1733'],
      #  ['Plantago major : some garbage ,more of it', 'Plantago major: some garbage, more of it'],
      #  ["Parus minor\n\r L. 1774", 'Parus minor L. 1774'],
      #  ['Ceanothus divergens ssp. confusus (J. T. Howell) Abrams', 'Ceanothus divergens ssp. confusus (J. T. Howell) Abrams']
      ['Plantago     major     L.   ', 'Plantago major L.']
      ]
    strings.each do |ns|
      NameString.normalize_name_string(ns[0]).should == ns[1]
    end
  end
end


describe NameString do
  before :all do
    Scenario.load :application
    @data_source = DataSource.find(1)
    @user = User.find(1)
  end
  
  after :all do
    truncate_all_tables
  end

  #it { should have_one(:kingdom) }
  #it { should have_many(:name_indices) }

  it "should require a valid #name" do
    NameString.gen( :name => 'Plantago' ).should be_valid
    NameString.build( :name => 'Plantago' ).should_not be_valid # because there's already Plantago
  end
  
  it "should find a name by canonical form" do
    name_strings = NameString.search("adnaria frondosa", nil, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should == 1
    name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
  end
  
  it "should find a name with any words sequence" do
    name_strings = NameString.search("frondosa adnaria", nil, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should == 1
    name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
  end
  
  it "should_find name by partial canonical form" do
     name_strings = NameString.search("frondosa adn%", nil, nil, 1, 10)
     name_strings.should_not be_nil
     name_strings.size.should > 0
     name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
   end
   
   it "should find name with author" do
     search_term = "Adnaria frondosa (L.)"
     name_strings = NameString.search(search_term, nil, nil, 1, 10)
     name_strings.should_not be_nil
     name_strings.size.should > 0
     name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
   end
   
   it "should find a name by canonical form in a data_source" do
     name_strings = NameString.search("adnaria frondosa", @data_source.id, nil, 1, 10)
     name_strings.should_not be_nil
     name_strings.size.should > 0
     name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
   end
   
   it "should find a name by partial canonical form in a datasource" do
     name_strings = NameString.search("adn%", @data_source.id, nil, 1, 10)
     name_strings.should_not be_nil
     name_strings.size.should > 0
     name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
   end
   
   it "should find name with author in a datasource" do
     search_term = "Adnaria frondosa (L.)"
     name_strings = NameString.search(search_term, @data_source.id, nil, 1, 10)
     name_strings.should_not be_nil
     name_strings.size.should > 0
     name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
   end
   
   it "should not find name if it is not in a datasource" do
     search_term = "Adnaria frondosa (L.)"
     name_strings = NameString.search(search_term, 100, nil, 1, 10)
     name_strings.size.should == 0
   end
   
   it "should find a name in datasources belonging to a user" do
     name_strings = NameString.search("adnaria L", nil, @user.id, 1, 10)
     name_strings.should_not be_nil
     name_strings.size.should > 0
     name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
   end
  
   it "should find name with author in datasources belogning to a user" do
     search_term = "Adnaria frondosa (L.)"
     name_strings = NameString.search(search_term, nil, @user.id, 1, 10)
     name_strings.should_not be_nil
     name_strings.size.should > 0
     name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
   end
   
   it "should not find a name which does not belong to a user" do
     search_term = "Adnaria frondosa (L.)"
     name_strings = NameString.search(search_term, nil, 100, 1, 10)
     name_strings.should_not be_nil
     name_strings.size.should == 0
   end
   
   it "should find genera with gen: qualifier" do
    search_term = "gen:Hig%"
    name_strings = NameString.search(search_term, nil, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should > 0
   end
  
  it "should work with several qualifiers" do
    search_term = "gen:Hig% sp:plum%"
    name_strings = NameString.search(search_term, nil, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should > 0
  end
  
  it "should ignore wrong qulaifiers" do
    search_term = "gen:Hig% wrong:plum%"
    name_strings = NameString.search(search_term, nil, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should == 0
  end
  
  it "should work with canonical form search" do
    search_term = "can:Higena plumigera gen:Hig%"
    name_strings = NameString.search(search_term, nil, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should == 5
    search_term = "can:Higena plumigera"
    name_strings = NameString.search(search_term, nil, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should == 5
  end
  
  it "should work with all qualifiers" do
    search_terms = ['can:Higena plumigera', 'yr:1787', 'sp:plumigera', 'gen:Adnatosphaeridium', 'uni:Higena', 'au:Williams au:G.']
    search_terms.each do |st|
      name_strings = NameString.search(st, nil, nil, 1, 10)
      name_strings.should_not be_nil
      name_strings.size.should > 0
    end
  end
end

