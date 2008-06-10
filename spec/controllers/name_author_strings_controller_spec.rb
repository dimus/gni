require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameAuthorStringsController do
  describe "handling GET /name_author_strings" do

    before(:each) do
      @name_author_string = mock_model(NameAuthorString)
      NameAuthorString.stub!(:find).and_return([@name_author_string])
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
  
    it "should find all name_author_strings" do
      NameAuthorString.should_receive(:find).with(:all).and_return([@name_author_string])
      do_get
    end
  
    it "should assign the found name_author_strings for the view" do
      do_get
      assigns[:name_author_strings].should == [@name_author_string]
    end
  end

  describe "handling GET /name_author_strings.xml" do

    before(:each) do
      @name_author_strings = mock("Array of NameAuthorStrings", :to_xml => "XML")
      NameAuthorString.stub!(:find).and_return(@name_author_strings)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all name_author_strings" do
      NameAuthorString.should_receive(:find).with(:all).and_return(@name_author_strings)
      do_get
    end
  
    it "should render the found name_author_strings as xml" do
      @name_author_strings.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_author_strings/1" do

    before(:each) do
      @name_author_string = mock_model(NameAuthorString)
      NameAuthorString.stub!(:find).and_return(@name_author_string)
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
  
    it "should find the name_author_string requested" do
      NameAuthorString.should_receive(:find).with("1").and_return(@name_author_string)
      do_get
    end
  
    it "should assign the found name_author_string for the view" do
      do_get
      assigns[:name_author_string].should equal(@name_author_string)
    end
  end

  describe "handling GET /name_author_strings/1.xml" do

    before(:each) do
      @name_author_string = mock_model(NameAuthorString, :to_xml => "XML")
      NameAuthorString.stub!(:find).and_return(@name_author_string)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the name_author_string requested" do
      NameAuthorString.should_receive(:find).with("1").and_return(@name_author_string)
      do_get
    end
  
    it "should render the found name_author_string as xml" do
      @name_author_string.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_author_strings/new" do

    before(:each) do
      @name_author_string = mock_model(NameAuthorString)
      NameAuthorString.stub!(:new).and_return(@name_author_string)
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
  
    it "should create an new name_author_string" do
      NameAuthorString.should_receive(:new).and_return(@name_author_string)
      do_get
    end
  
    it "should not save the new name_author_string" do
      @name_author_string.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new name_author_string for the view" do
      do_get
      assigns[:name_author_string].should equal(@name_author_string)
    end
  end

  describe "handling GET /name_author_strings/1/edit" do

    before(:each) do
      @name_author_string = mock_model(NameAuthorString)
      NameAuthorString.stub!(:find).and_return(@name_author_string)
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
  
    it "should find the name_author_string requested" do
      NameAuthorString.should_receive(:find).and_return(@name_author_string)
      do_get
    end
  
    it "should assign the found NameAuthorString for the view" do
      do_get
      assigns[:name_author_string].should equal(@name_author_string)
    end
  end

  describe "handling POST /name_author_strings" do

    before(:each) do
      @name_author_string = mock_model(NameAuthorString, :to_param => "1")
      NameAuthorString.stub!(:new).and_return(@name_author_string)
    end
    
    describe "with successful save" do
  
      def do_post
        @name_author_string.should_receive(:save).and_return(true)
        post :create, :name_author_string => {}
      end
  
      it "should create a new name_author_string" do
        NameAuthorString.should_receive(:new).with({}).and_return(@name_author_string)
        do_post
      end

      it "should redirect to the new name_author_string" do
        do_post
        response.should redirect_to(name_author_string_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @name_author_string.should_receive(:save).and_return(false)
        post :create, :name_author_string => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /name_author_strings/1" do

    before(:each) do
      @name_author_string = mock_model(NameAuthorString, :to_param => "1")
      NameAuthorString.stub!(:find).and_return(@name_author_string)
    end
    
    describe "with successful update" do

      def do_put
        @name_author_string.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the name_author_string requested" do
        NameAuthorString.should_receive(:find).with("1").and_return(@name_author_string)
        do_put
      end

      it "should update the found name_author_string" do
        do_put
        assigns(:name_author_string).should equal(@name_author_string)
      end

      it "should assign the found name_author_string for the view" do
        do_put
        assigns(:name_author_string).should equal(@name_author_string)
      end

      it "should redirect to the name_author_string" do
        do_put
        response.should redirect_to(name_author_string_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @name_author_string.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /name_author_strings/1" do

    before(:each) do
      @name_author_string = mock_model(NameAuthorString, :destroy => true)
      NameAuthorString.stub!(:find).and_return(@name_author_string)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the name_author_string requested" do
      NameAuthorString.should_receive(:find).with("1").and_return(@name_author_string)
      do_delete
    end
  
    it "should call destroy on the found name_author_string" do
      @name_author_string.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the name_author_strings list" do
      do_delete
      response.should redirect_to(name_author_strings_url)
    end
  end
end
