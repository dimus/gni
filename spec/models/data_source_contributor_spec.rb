require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DataSourceContributor do
  fixtures :users, :data_sources, :data_source_contributors
  
  before(:each) do
    @aaron_user = users(:aaron)
    @quentin_user = users(:quentin)
    @birds_ds = data_sources(:birds_nhm)
    @bees_ds = data_sources(:bees_nhm)
    @data_source_contributor = DataSourceContributor.new({:user => @aaron_user, :data_source => @bees_ds})
  end

  it "should be valid" do
    @data_source_contributor.should be_valid
  end
  
  it "should require user" do
    @data_source_contributor.user = nil
    @data_source_contributor.should_not be_valid
  end
  
  it "should require data_source" do
    @data_source_contributor.data_source = nil
    @data_source_contributor.should_not be_valid
  end
  
  it "user and data source combindation should be unique" do
    lambda {
      DataSourceContributor.create({:user => @aaron_user, :data_source => @bees_ds})
      DataSourceContributor.create({:user => @aaron_user, :data_source => @bees_ds})    
    }.should raise_error
  end
  
  # it "should not delete last contributor for a source"
  #   lambda {
  #     ds = DataSource.create({:title => 'Example 686', :description => 'Description',
  #     :data_url => 'http://example.com/data_url.xml', :data_zip_compressed => false, :metadata_url => nil, :logo_url => 'http://example.com/images/logo.png')
  #     @data_source_contributor.destroy
  #   }.should raise_error
  # end
    
  
end