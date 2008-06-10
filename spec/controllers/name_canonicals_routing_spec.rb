require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameCanonicalsController do
  describe "route generation" do

    it "should map { :controller => 'name_canonicals', :action => 'index' } to /name_canonicals" do
      route_for(:controller => "name_canonicals", :action => "index").should == "/name_canonicals"
    end
  
    it "should map { :controller => 'name_canonicals', :action => 'new' } to /name_canonicals/new" do
      route_for(:controller => "name_canonicals", :action => "new").should == "/name_canonicals/new"
    end
  
    it "should map { :controller => 'name_canonicals', :action => 'show', :id => 1 } to /name_canonicals/1" do
      route_for(:controller => "name_canonicals", :action => "show", :id => 1).should == "/name_canonicals/1"
    end
  
    it "should map { :controller => 'name_canonicals', :action => 'edit', :id => 1 } to /name_canonicals/1/edit" do
      route_for(:controller => "name_canonicals", :action => "edit", :id => 1).should == "/name_canonicals/1/edit"
    end
  
    it "should map { :controller => 'name_canonicals', :action => 'update', :id => 1} to /name_canonicals/1" do
      route_for(:controller => "name_canonicals", :action => "update", :id => 1).should == "/name_canonicals/1"
    end
  
    it "should map { :controller => 'name_canonicals', :action => 'destroy', :id => 1} to /name_canonicals/1" do
      route_for(:controller => "name_canonicals", :action => "destroy", :id => 1).should == "/name_canonicals/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'name_canonicals', action => 'index' } from GET /name_canonicals" do
      params_from(:get, "/name_canonicals").should == {:controller => "name_canonicals", :action => "index"}
    end
  
    it "should generate params { :controller => 'name_canonicals', action => 'new' } from GET /name_canonicals/new" do
      params_from(:get, "/name_canonicals/new").should == {:controller => "name_canonicals", :action => "new"}
    end
  
    it "should generate params { :controller => 'name_canonicals', action => 'create' } from POST /name_canonicals" do
      params_from(:post, "/name_canonicals").should == {:controller => "name_canonicals", :action => "create"}
    end
  
    it "should generate params { :controller => 'name_canonicals', action => 'show', id => '1' } from GET /name_canonicals/1" do
      params_from(:get, "/name_canonicals/1").should == {:controller => "name_canonicals", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_canonicals', action => 'edit', id => '1' } from GET /name_canonicals/1;edit" do
      params_from(:get, "/name_canonicals/1/edit").should == {:controller => "name_canonicals", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_canonicals', action => 'update', id => '1' } from PUT /name_canonicals/1" do
      params_from(:put, "/name_canonicals/1").should == {:controller => "name_canonicals", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_canonicals', action => 'destroy', id => '1' } from DELETE /name_canonicals/1" do
      params_from(:delete, "/name_canonicals/1").should == {:controller => "name_canonicals", :action => "destroy", :id => "1"}
    end
  end
end
