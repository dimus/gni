require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_strings/index.html.haml" do

  it "should_render without search" do
    render "/name_strings/index.html.haml"
    response.should be_success
  end
end
