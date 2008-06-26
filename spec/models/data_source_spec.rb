require File.dirname(__FILE__) + '/../spec_helper'

describe DataSource do
  
  it "should have title" do
    lambda do
      u = create_data_source(:title => nil)
      u.errors.on(:title).should_not be_nil
    end.should_not change(DataSource, :count)
  end

  it "should have data_url" do
    lambda do
      u = create_data_source(:data_url => nil)
      u.errors.on(:data_url).should_not be_nil
    end.should_not change(DataSource, :count)
  end
  
  describe "data_url should be url" do
    [
      "http://example.com/something",
      "https://example.com/somethingelse",
    ].each do |durl|
      it "'#{durl}'" do
        lambda do
          u = create_data_source(:data_url => durl)
          u.errors.on(:data_url).should be_nil
        end.should change(DataSource, :count).by(1)
      end
    end
  end
  
  describe "data_url should not be anything but url" do
    [
      "ftp://example.com/something",
      "svn://example.com/somethingelse",
    ].each do |durl|
      it "'#{durl}'" do
        lambda do
          u = create_data_source(:data_url => durl)
          u.errors.on(:data_url).should_not be_nil
        end.should_not change(DataSource, :count)
      end
    end
  end
  

protected
  def create_data_source(options = {})
    record = DataSource.new({:title => 'Index Fungorum', :description => 'Description',
    :data_url => 'http://example.com/data_url.xml', :data_zip_compressed => false, :metadata_url => nil, :logo_url => 'http://example.com/images/logo.png'}.merge(options))
    record.save
    record
  end
end
