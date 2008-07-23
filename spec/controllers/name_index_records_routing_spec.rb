require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameIndexRecordsController do
  describe "route generation" do

    it "should map { :controller => 'name_index_records', :action => 'index' } to /name_index_records" do
      route_for(:controller => "name_index_records", :action => "index").should == "/name_index_records"
    end
  
    it "should map { :controller => 'name_index_records', :action => 'new' } to /name_index_records/new" do
      route_for(:controller => "name_index_records", :action => "new").should == "/name_index_records/new"
    end
  
    it "should map { :controller => 'name_index_records', :action => 'show', :id => 1 } to /name_index_records/1" do
      route_for(:controller => "name_index_records", :action => "show", :id => 1).should == "/name_index_records/1"
    end
  
    it "should map { :controller => 'name_index_records', :action => 'edit', :id => 1 } to /name_index_records/1/edit" do
      route_for(:controller => "name_index_records", :action => "edit", :id => 1).should == "/name_index_records/1/edit"
    end
  
    it "should map { :controller => 'name_index_records', :action => 'update', :id => 1} to /name_index_records/1" do
      route_for(:controller => "name_index_records", :action => "update", :id => 1).should == "/name_index_records/1"
    end
  
    it "should map { :controller => 'name_index_records', :action => 'destroy', :id => 1} to /name_index_records/1" do
      route_for(:controller => "name_index_records", :action => "destroy", :id => 1).should == "/name_index_records/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'name_index_records', action => 'index' } from GET /name_index_records" do
      params_from(:get, "/name_index_records").should == {:controller => "name_index_records", :action => "index"}
    end
  
    it "should generate params { :controller => 'name_index_records', action => 'new' } from GET /name_index_records/new" do
      params_from(:get, "/name_index_records/new").should == {:controller => "name_index_records", :action => "new"}
    end
  
    it "should generate params { :controller => 'name_index_records', action => 'create' } from POST /name_index_records" do
      params_from(:post, "/name_index_records").should == {:controller => "name_index_records", :action => "create"}
    end
  
    it "should generate params { :controller => 'name_index_records', action => 'show', id => '1' } from GET /name_index_records/1" do
      params_from(:get, "/name_index_records/1").should == {:controller => "name_index_records", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_index_records', action => 'edit', id => '1' } from GET /name_index_records/1;edit" do
      params_from(:get, "/name_index_records/1/edit").should == {:controller => "name_index_records", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_index_records', action => 'update', id => '1' } from PUT /name_index_records/1" do
      params_from(:put, "/name_index_records/1").should == {:controller => "name_index_records", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'name_index_records', action => 'destroy', id => '1' } from DELETE /name_index_records/1" do
      params_from(:delete, "/name_index_records/1").should == {:controller => "name_index_records", :action => "destroy", :id => "1"}
    end
  end
end
