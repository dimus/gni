require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_index_records/new.html.erb" do
  include NameIndexRecordsHelper
  
  before(:each) do
    @name_index_record = mock_model(NameIndexRecord)
    @name_index_record.stub!(:new_record?).and_return(true)
    @name_index_record.stub!(:name_index).and_return()
    @name_index_record.stub!(:kingdom).and_return()
    @name_index_record.stub!(:rank).and_return("MyString")
    @name_index_record.stub!(:local_id).and_return("MyString")
    @name_index_record.stub!(:global_id).and_return("MyString")
    @name_index_record.stub!(:url).and_return("MyString")
    assigns[:name_index_record] = @name_index_record
  end

  it "should render new form" do
    render "/name_index_records/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", name_index_records_path) do
      with_tag("input#name_index_record_name_index[name=?]", "name_index_record[name_index]")
      with_tag("input#name_index_record_kingdom[name=?]", "name_index_record[kingdom]")
      with_tag("input#name_index_record_rank[name=?]", "name_index_record[rank]")
      with_tag("input#name_index_record_url[name=?]", "name_index_record[url]")
    end
  end
end


