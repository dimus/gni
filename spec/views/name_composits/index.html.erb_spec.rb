require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_composits/index.html.erb" do
  include NameCompositsHelper
  
  before(:each) do
    name_composit_98 = mock_model(NameComposit)
    name_composit_98.should_receive(:name_canonical).and_return()
    name_composit_98.should_receive(:name_author_string).and_return()
    name_composit_98.should_receive(:name_year).and_return()
    name_composit_98.should_receive(:confirmed).and_return(false)
    name_composit_99 = mock_model(NameComposit)
    name_composit_99.should_receive(:name_canonical).and_return()
    name_composit_99.should_receive(:name_author_string).and_return()
    name_composit_99.should_receive(:name_year).and_return()
    name_composit_99.should_receive(:confirmed).and_return(false)

    assigns[:name_composits] = [name_composit_98, name_composit_99]
  end

  it "should render list of name_composits" do
    render "/name_composits/index.html.erb"
    response.should have_tag("tr>td", '', 2)
    response.should have_tag("tr>td", '', 2)
    response.should have_tag("tr>td", '', 2)
    response.should have_tag("tr>td", false, 2)
  end
end

