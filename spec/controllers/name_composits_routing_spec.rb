require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameCompositsController do
  describe "route generation" do

    it "should map { :controller => 'name_composits', :action => 'index' } to /name_composits" do
      route_for(:controller => "name_composits", :action => "index").should == "/name_composits"
    end
  
    it "should map { :controller => 'name_composits', :action => 'new' } to /name_composits/new" do
      route_for(:controller => "name_composits", :action => "new").should == "/name_composits/new"
    end
  
    it "should map { :controller => 'name_composits', :action => 'show', :id => 1 } to /name_composits/1" do
      route_for(:controller => "name_composits", :action => "show", :id => 1).should == "/name_composits/1"
    end
  
    it "should map { :controller => 'name_composits', :action => 'edit', :id => 1 } to /name_composits/1/edit" do
      route_for(:controller => "name_composits", :action => "edit", :id => 1).should == "/name_composits/1/edit"
    end
  
    it "should map { :controller => 'name_composits', :action => 'update', :id => 1} to /name_composits/1" do
      route_for(:controller => "name_composits", :action => "update", :id => 1).should == "/name_composits/1"
    end
  
    it "should map { :controller => 'name_composits', :action => 'destroy', :id => 1} to /name_composits/1" do
      route_for(:controller => "name_composits", :action => "destroy", :id => 1).should == "/name_composits/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'name_composits', action => 'index' } from GET /name_composits" do
      params_from(:get, "/name_composits").should == {:controller => "name_composits", :action => "index"}
    end
  
    it "should generate params { :controller => 'name_composits', action => 'new' } from GET /name_composits/new" do
      params_from(:get, "/name_composits/new").should == {:controller => "name_composits", :action => "new"}
    end
  
    it "should generate params { :controller => 'name_composits', action => 'create' } from POST /name_composits" do
      params_from(:post, "/name_composits").should == {:controller => "name_composits", :action => "create"}
    end
  
    it "should generate params { :controller => 'name_composits', action => 'show', id => '1' } from GET /name_composits/1" do
      params_from(:get, "/name_composits/1").should == {:controller => "name_composits", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_composits', action => 'edit', id => '1' } from GET /name_composits/1;edit" do
      params_from(:get, "/name_composits/1/edit").should == {:controller => "name_composits", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_composits', action => 'update', id => '1' } from PUT /name_composits/1" do
      params_from(:put, "/name_composits/1").should == {:controller => "name_composits", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_composits', action => 'destroy', id => '1' } from DELETE /name_composits/1" do
      params_from(:delete, "/name_composits/1").should == {:controller => "name_composits", :action => "destroy", :id => "1"}
    end
  end
end
