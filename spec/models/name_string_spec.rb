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
    name_strings.size.should > 0
    name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
  end
  
  it "should_find name by partial canonical form" do
    name_strings = NameString.search("adn%", nil, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should > 0
    name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
  end
  
  it "should find name with author" do
    search_term = NameString.normalize_name_string("Adnaria frondosa (L.)%")
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
    search_term = NameString.normalize_name_string("Adnaria frondosa (L.)%")
    name_strings = NameString.search(search_term, @data_source, nil, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should > 0
    name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
  end
  
  it "should not find name if it is not in a datasource" do
    search_term = NameString.normalize_name_string("Adnaria frondosa (L.)%")
    name_strings = NameString.search(search_term, 100, nil, 1, 10)
    name_strings.size.should == 0
  end
  
  it "should find a name in datasources belonging to a user" do
    name_strings = NameString.search("adnaria frondosa", nil, @user.id, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should > 0
    name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
  end

  it "should find name with author in datasources belogning to a user" do
    search_term = NameString.normalize_name_string("Adnaria frondosa (L.)%")
    name_strings = NameString.search(search_term, nil, @user.id, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should > 0
    name_strings[0].name.should == 'Adnaria frondosa (L.) Kuntze'
  end
  
  it "should not find a name which does not belong to a user" do
    search_term = NameString.normalize_name_string("Adnaria frondosa (L.)%")
    name_strings = NameString.search(search_term, nil, 100, 1, 10)
    name_strings.should_not be_nil
    name_strings.size.should == 0
  end
  
end

