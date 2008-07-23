require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_index_records/index.html.erb" do
  include NameIndexRecordsHelper
  
  before(:each) do
    name_index_record_98 = mock_model(NameIndexRecord)
    name_index_record_98.should_receive(:name_index).and_return()
    name_index_record_98.should_receive(:kingdom).and_return()
    name_index_record_98.should_receive(:rank).and_return("MyString")
    name_index_record_98.should_receive(:local_id).and_return("MyString")
    name_index_record_98.should_receive(:global_id).and_return("MyString")
    name_index_record_98.should_receive(:url).and_return("MyString")
    name_index_record_99 = mock_model(NameIndexRecord)
    name_index_record_99.should_receive(:name_index).and_return()
    name_index_record_99.should_receive(:kingdom).and_return()
    name_index_record_99.should_receive(:rank).and_return("MyString")
    name_index_record_99.should_receive(:local_id).and_return("MyString")
    name_index_record_99.should_receive(:global_id).and_return("MyString")
    name_index_record_99.should_receive(:url).and_return("MyString")

    assigns[:name_index_records] = [name_index_record_98, name_index_record_99]
  end

  it "should render list of name_index_records" do
    render "/name_index_records/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

