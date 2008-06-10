require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_composits/new.html.erb" do
  include NameCompositsHelper
  
  before(:each) do
    @name_composit = mock_model(NameComposit)
    @name_composit.stub!(:new_record?).and_return(true)
    @name_composit.stub!(:name_canonical).and_return()
    @name_composit.stub!(:name_author_string).and_return()
    @name_composit.stub!(:name_year).and_return()
    @name_composit.stub!(:confirmed).and_return(false)
    assigns[:name_composit] = @name_composit
  end

  it "should render new form" do
    render "/name_composits/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", name_composits_path) do
      with_tag("input#name_composit_name_canonical[name=?]", "name_composit[name_canonical]")
      with_tag("input#name_composit_name_author_string[name=?]", "name_composit[name_author_string]")
      with_tag("input#name_composit_name_year[name=?]", "name_composit[name_year]")
      with_tag("input#name_composit_confirmed[name=?]", "name_composit[confirmed]")
    end
  end
end


