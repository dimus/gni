require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StatisticsController do
  describe "route generation" do

    it "should map { :controller => 'statistics', :action => 'index' } to /statistics" do
      route_for(:controller => "statistics", :action => "index").should == "/statistics"
    end
  
    it "should map { :controller => 'statistics', :action => 'new' } to /statistics/new" do
      route_for(:controller => "statistics", :action => "new").should == "/statistics/new"
    end
  
    it "should map { :controller => 'statistics', :action => 'show', :id => 1 } to /statistics/1" do
      route_for(:controller => "statistics", :action => "show", :id => 1).should == "/statistics/1"
    end
  
    it "should map { :controller => 'statistics', :action => 'edit', :id => 1 } to /statistics/1/edit" do
      route_for(:controller => "statistics", :action => "edit", :id => 1).should == "/statistics/1/edit"
    end
  
    it "should map { :controller => 'statistics', :action => 'update', :id => 1} to /statistics/1" do
      route_for(:controller => "statistics", :action => "update", :id => 1).should == "/statistics/1"
    end
  
    it "should map { :controller => 'statistics', :action => 'destroy', :id => 1} to /statistics/1" do
      route_for(:controller => "statistics", :action => "destroy", :id => 1).should == "/statistics/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'statistics', action => 'index' } from GET /statistics" do
      params_from(:get, "/statistics").should == {:controller => "statistics", :action => "index"}
    end
  
    it "should generate params { :controller => 'statistics', action => 'new' } from GET /statistics/new" do
      params_from(:get, "/statistics/new").should == {:controller => "statistics", :action => "new"}
    end
  
    it "should generate params { :controller => 'statistics', action => 'create' } from POST /statistics" do
      params_from(:post, "/statistics").should == {:controller => "statistics", :action => "create"}
    end
  
    it "should generate params { :controller => 'statistics', action => 'show', id => '1' } from GET /statistics/1" do
      params_from(:get, "/statistics/1").should == {:controller => "statistics", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'statistics', action => 'edit', id => '1' } from GET /statistics/1;edit" do
      params_from(:get, "/statistics/1/edit").should == {:controller => "statistics", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'statistics', action => 'update', id => '1' } from PUT /statistics/1" do
      params_from(:put, "/statistics/1").should == {:controller => "statistics", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'statistics', action => 'destroy', id => '1' } from DELETE /statistics/1" do
      params_from(:delete, "/statistics/1").should == {:controller => "statistics", :action => "destroy", :id => "1"}
    end
  end
end
