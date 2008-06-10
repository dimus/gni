require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameYearsController do
  describe "route generation" do

    it "should map { :controller => 'name_years', :action => 'index' } to /name_years" do
      route_for(:controller => "name_years", :action => "index").should == "/name_years"
    end
  
    it "should map { :controller => 'name_years', :action => 'new' } to /name_years/new" do
      route_for(:controller => "name_years", :action => "new").should == "/name_years/new"
    end
  
    it "should map { :controller => 'name_years', :action => 'show', :id => 1 } to /name_years/1" do
      route_for(:controller => "name_years", :action => "show", :id => 1).should == "/name_years/1"
    end
  
    it "should map { :controller => 'name_years', :action => 'edit', :id => 1 } to /name_years/1/edit" do
      route_for(:controller => "name_years", :action => "edit", :id => 1).should == "/name_years/1/edit"
    end
  
    it "should map { :controller => 'name_years', :action => 'update', :id => 1} to /name_years/1" do
      route_for(:controller => "name_years", :action => "update", :id => 1).should == "/name_years/1"
    end
  
    it "should map { :controller => 'name_years', :action => 'destroy', :id => 1} to /name_years/1" do
      route_for(:controller => "name_years", :action => "destroy", :id => 1).should == "/name_years/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'name_years', action => 'index' } from GET /name_years" do
      params_from(:get, "/name_years").should == {:controller => "name_years", :action => "index"}
    end
  
    it "should generate params { :controller => 'name_years', action => 'new' } from GET /name_years/new" do
      params_from(:get, "/name_years/new").should == {:controller => "name_years", :action => "new"}
    end
  
    it "should generate params { :controller => 'name_years', action => 'create' } from POST /name_years" do
      params_from(:post, "/name_years").should == {:controller => "name_years", :action => "create"}
    end
  
    it "should generate params { :controller => 'name_years', action => 'show', id => '1' } from GET /name_years/1" do
      params_from(:get, "/name_years/1").should == {:controller => "name_years", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_years', action => 'edit', id => '1' } from GET /name_years/1;edit" do
      params_from(:get, "/name_years/1/edit").should == {:controller => "name_years", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_years', action => 'update', id => '1' } from PUT /name_years/1" do
      params_from(:put, "/name_years/1").should == {:controller => "name_years", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_years', action => 'destroy', id => '1' } from DELETE /name_years/1" do
      params_from(:delete, "/name_years/1").should == {:controller => "name_years", :action => "destroy", :id => "1"}
    end
  end
end
