require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_composits/show.html.erb" do
  include NameCompositsHelper
  
  before(:each) do
    @name_composit = mock_model(NameComposit)
    @name_composit.stub!(:name_canonical).and_return()
    @name_composit.stub!(:name_author_string).and_return()
    @name_composit.stub!(:name_year).and_return()
    @name_composit.stub!(:confirmed).and_return(false)

    assigns[:name_composit] = @name_composit
  end

  it "should render attributes in <p>" do
    render "/name_composits/show.html.erb"
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/als/)
  end
end

