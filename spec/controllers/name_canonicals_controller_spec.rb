require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameCanonicalsController do
  describe "handling GET /name_canonicals" do

    before(:each) do
      @name_canonical = mock_model(NameCanonical)
      NameCanonical.stub!(:find).and_return([@name_canonical])
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
  
    it "should find all name_canonicals" do
      NameCanonical.should_receive(:find).with(:all).and_return([@name_canonical])
      do_get
    end
  
    it "should assign the found name_canonicals for the view" do
      do_get
      assigns[:name_canonicals].should == [@name_canonical]
    end
  end

  describe "handling GET /name_canonicals.xml" do

    before(:each) do
      @name_canonicals = mock("Array of NameCanonicals", :to_xml => "XML")
      NameCanonical.stub!(:find).and_return(@name_canonicals)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all name_canonicals" do
      NameCanonical.should_receive(:find).with(:all).and_return(@name_canonicals)
      do_get
    end
  
    it "should render the found name_canonicals as xml" do
      @name_canonicals.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_canonicals/1" do

    before(:each) do
      @name_canonical = mock_model(NameCanonical)
      NameCanonical.stub!(:find).and_return(@name_canonical)
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
  
    it "should find the name_canonical requested" do
      NameCanonical.should_receive(:find).with("1").and_return(@name_canonical)
      do_get
    end
  
    it "should assign the found name_canonical for the view" do
      do_get
      assigns[:name_canonical].should equal(@name_canonical)
    end
  end

  describe "handling GET /name_canonicals/1.xml" do

    before(:each) do
      @name_canonical = mock_model(NameCanonical, :to_xml => "XML")
      NameCanonical.stub!(:find).and_return(@name_canonical)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the name_canonical requested" do
      NameCanonical.should_receive(:find).with("1").and_return(@name_canonical)
      do_get
    end
  
    it "should render the found name_canonical as xml" do
      @name_canonical.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_canonicals/new" do

    before(:each) do
      @name_canonical = mock_model(NameCanonical)
      NameCanonical.stub!(:new).and_return(@name_canonical)
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
  
    it "should create an new name_canonical" do
      NameCanonical.should_receive(:new).and_return(@name_canonical)
      do_get
    end
  
    it "should not save the new name_canonical" do
      @name_canonical.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new name_canonical for the view" do
      do_get
      assigns[:name_canonical].should equal(@name_canonical)
    end
  end

  describe "handling GET /name_canonicals/1/edit" do

    before(:each) do
      @name_canonical = mock_model(NameCanonical)
      NameCanonical.stub!(:find).and_return(@name_canonical)
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
  
    it "should find the name_canonical requested" do
      NameCanonical.should_receive(:find).and_return(@name_canonical)
      do_get
    end
  
    it "should assign the found NameCanonical for the view" do
      do_get
      assigns[:name_canonical].should equal(@name_canonical)
    end
  end

  describe "handling POST /name_canonicals" do

    before(:each) do
      @name_canonical = mock_model(NameCanonical, :to_param => "1")
      NameCanonical.stub!(:new).and_return(@name_canonical)
    end
    
    describe "with successful save" do
  
      def do_post
        @name_canonical.should_receive(:save).and_return(true)
        post :create, :name_canonical => {}
      end
  
      it "should create a new name_canonical" do
        NameCanonical.should_receive(:new).with({}).and_return(@name_canonical)
        do_post
      end

      it "should redirect to the new name_canonical" do
        do_post
        response.should redirect_to(name_canonical_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @name_canonical.should_receive(:save).and_return(false)
        post :create, :name_canonical => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /name_canonicals/1" do

    before(:each) do
      @name_canonical = mock_model(NameCanonical, :to_param => "1")
      NameCanonical.stub!(:find).and_return(@name_canonical)
    end
    
    describe "with successful update" do

      def do_put
        @name_canonical.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the name_canonical requested" do
        NameCanonical.should_receive(:find).with("1").and_return(@name_canonical)
        do_put
      end

      it "should update the found name_canonical" do
        do_put
        assigns(:name_canonical).should equal(@name_canonical)
      end

      it "should assign the found name_canonical for the view" do
        do_put
        assigns(:name_canonical).should equal(@name_canonical)
      end

      it "should redirect to the name_canonical" do
        do_put
        response.should redirect_to(name_canonical_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @name_canonical.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /name_canonicals/1" do

    before(:each) do
      @name_canonical = mock_model(NameCanonical, :destroy => true)
      NameCanonical.stub!(:find).and_return(@name_canonical)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the name_canonical requested" do
      NameCanonical.should_receive(:find).with("1").and_return(@name_canonical)
      do_delete
    end
  
    it "should call destroy on the found name_canonical" do
      @name_canonical.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the name_canonicals list" do
      do_delete
      response.should redirect_to(name_canonicals_url)
    end
  end
end
