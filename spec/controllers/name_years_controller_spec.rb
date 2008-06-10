require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameYearsController do
  describe "handling GET /name_years" do

    before(:each) do
      @name_year = mock_model(NameYear)
      NameYear.stub!(:find).and_return([@name_year])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all name_years" do
      NameYear.should_receive(:find).with(:all).and_return([@name_year])
      do_get
    end
  
    it "should assign the found name_years for the view" do
      do_get
      assigns[:name_years].should == [@name_year]
    end
  end

  describe "handling GET /name_years.xml" do

    before(:each) do
      @name_years = mock("Array of NameYears", :to_xml => "XML")
      NameYear.stub!(:find).and_return(@name_years)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all name_years" do
      NameYear.should_receive(:find).with(:all).and_return(@name_years)
      do_get
    end
  
    it "should render the found name_years as xml" do
      @name_years.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_years/1" do

    before(:each) do
      @name_year = mock_model(NameYear)
      NameYear.stub!(:find).and_return(@name_year)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the name_year requested" do
      NameYear.should_receive(:find).with("1").and_return(@name_year)
      do_get
    end
  
    it "should assign the found name_year for the view" do
      do_get
      assigns[:name_year].should equal(@name_year)
    end
  end

  describe "handling GET /name_years/1.xml" do

    before(:each) do
      @name_year = mock_model(NameYear, :to_xml => "XML")
      NameYear.stub!(:find).and_return(@name_year)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the name_year requested" do
      NameYear.should_receive(:find).with("1").and_return(@name_year)
      do_get
    end
  
    it "should render the found name_year as xml" do
      @name_year.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_years/new" do

    before(:each) do
      @name_year = mock_model(NameYear)
      NameYear.stub!(:new).and_return(@name_year)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new name_year" do
      NameYear.should_receive(:new).and_return(@name_year)
      do_get
    end
  
    it "should not save the new name_year" do
      @name_year.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new name_year for the view" do
      do_get
      assigns[:name_year].should equal(@name_year)
    end
  end

  describe "handling GET /name_years/1/edit" do

    before(:each) do
      @name_year = mock_model(NameYear)
      NameYear.stub!(:find).and_return(@name_year)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the name_year requested" do
      NameYear.should_receive(:find).and_return(@name_year)
      do_get
    end
  
    it "should assign the found NameYear for the view" do
      do_get
      assigns[:name_year].should equal(@name_year)
    end
  end

  describe "handling POST /name_years" do

    before(:each) do
      @name_year = mock_model(NameYear, :to_param => "1")
      NameYear.stub!(:new).and_return(@name_year)
    end
    
    describe "with successful save" do
  
      def do_post
        @name_year.should_receive(:save).and_return(true)
        post :create, :name_year => {}
      end
  
      it "should create a new name_year" do
        NameYear.should_receive(:new).with({}).and_return(@name_year)
        do_post
      end

      it "should redirect to the new name_year" do
        do_post
        response.should redirect_to(name_year_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @name_year.should_receive(:save).and_return(false)
        post :create, :name_year => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /name_years/1" do

    before(:each) do
      @name_year = mock_model(NameYear, :to_param => "1")
      NameYear.stub!(:find).and_return(@name_year)
    end
    
    describe "with successful update" do

      def do_put
        @name_year.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the name_year requested" do
        NameYear.should_receive(:find).with("1").and_return(@name_year)
        do_put
      end

      it "should update the found name_year" do
        do_put
        assigns(:name_year).should equal(@name_year)
      end

      it "should assign the found name_year for the view" do
        do_put
        assigns(:name_year).should equal(@name_year)
      end

      it "should redirect to the name_year" do
        do_put
        response.should redirect_to(name_year_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @name_year.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /name_years/1" do

    before(:each) do
      @name_year = mock_model(NameYear, :destroy => true)
      NameYear.stub!(:find).and_return(@name_year)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the name_year requested" do
      NameYear.should_receive(:find).with("1").and_return(@name_year)
      do_delete
    end
  
    it "should call destroy on the found name_year" do
      @name_year.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the name_years list" do
      do_delete
      response.should redirect_to(name_years_url)
    end
  end
end
