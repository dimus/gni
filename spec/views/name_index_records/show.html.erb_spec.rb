require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_index_records/show.html.erb" do
  include NameIndexRecordsHelper
  
  before(:each) do
    @name_index_record = mock_model(NameIndexRecord)
    @name_index_record.stub!(:name_index).and_return()
    @name_index_record.stub!(:kingdom).and_return()
    @name_index_record.stub!(:rank).and_return("MyString")
    @name_index_record.stub!(:local_id).and_return("MyString")
    @name_index_record.stub!(:global_id).and_return("MyString")
    @name_index_record.stub!(:url).and_return("MyString")

    assigns[:name_index_record] = @name_index_record
  end

  it "should render attributes in <p>" do
    render "/name_index_records/show.html.erb"
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

