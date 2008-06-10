require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameCompositsController do
  describe "handling GET /name_composits" do

    before(:each) do
      @name_composit = mock_model(NameComposit)
      NameComposit.stub!(:find).and_return([@name_composit])
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
  
    it "should find all name_composits" do
      NameComposit.should_receive(:find).with(:all).and_return([@name_composit])
      do_get
    end
  
    it "should assign the found name_composits for the view" do
      do_get
      assigns[:name_composits].should == [@name_composit]
    end
  end

  describe "handling GET /name_composits.xml" do

    before(:each) do
      @name_composits = mock("Array of NameComposits", :to_xml => "XML")
      NameComposit.stub!(:find).and_return(@name_composits)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all name_composits" do
      NameComposit.should_receive(:find).with(:all).and_return(@name_composits)
      do_get
    end
  
    it "should render the found name_composits as xml" do
      @name_composits.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_composits/1" do

    before(:each) do
      @name_composit = mock_model(NameComposit)
      NameComposit.stub!(:find).and_return(@name_composit)
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
  
    it "should find the name_composit requested" do
      NameComposit.should_receive(:find).with("1").and_return(@name_composit)
      do_get
    end
  
    it "should assign the found name_composit for the view" do
      do_get
      assigns[:name_composit].should equal(@name_composit)
    end
  end

  describe "handling GET /name_composits/1.xml" do

    before(:each) do
      @name_composit = mock_model(NameComposit, :to_xml => "XML")
      NameComposit.stub!(:find).and_return(@name_composit)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the name_composit requested" do
      NameComposit.should_receive(:find).with("1").and_return(@name_composit)
      do_get
    end
  
    it "should render the found name_composit as xml" do
      @name_composit.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_composits/new" do

    before(:each) do
      @name_composit = mock_model(NameComposit)
      NameComposit.stub!(:new).and_return(@name_composit)
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
  
    it "should create an new name_composit" do
      NameComposit.should_receive(:new).and_return(@name_composit)
      do_get
    end
  
    it "should not save the new name_composit" do
      @name_composit.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new name_composit for the view" do
      do_get
      assigns[:name_composit].should equal(@name_composit)
    end
  end

  describe "handling GET /name_composits/1/edit" do

    before(:each) do
      @name_composit = mock_model(NameComposit)
      NameComposit.stub!(:find).and_return(@name_composit)
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
  
    it "should find the name_composit requested" do
      NameComposit.should_receive(:find).and_return(@name_composit)
      do_get
    end
  
    it "should assign the found NameComposit for the view" do
      do_get
      assigns[:name_composit].should equal(@name_composit)
    end
  end

  describe "handling POST /name_composits" do

    before(:each) do
      @name_composit = mock_model(NameComposit, :to_param => "1")
      NameComposit.stub!(:new).and_return(@name_composit)
    end
    
    describe "with successful save" do
  
      def do_post
        @name_composit.should_receive(:save).and_return(true)
        post :create, :name_composit => {}
      end
  
      it "should create a new name_composit" do
        NameComposit.should_receive(:new).with({}).and_return(@name_composit)
        do_post
      end

      it "should redirect to the new name_composit" do
        do_post
        response.should redirect_to(name_composit_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @name_composit.should_receive(:save).and_return(false)
        post :create, :name_composit => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /name_composits/1" do

    before(:each) do
      @name_composit = mock_model(NameComposit, :to_param => "1")
      NameComposit.stub!(:find).and_return(@name_composit)
    end
    
    describe "with successful update" do

      def do_put
        @name_composit.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the name_composit requested" do
        NameComposit.should_receive(:find).with("1").and_return(@name_composit)
        do_put
      end

      it "should update the found name_composit" do
        do_put
        assigns(:name_composit).should equal(@name_composit)
      end

      it "should assign the found name_composit for the view" do
        do_put
        assigns(:name_composit).should equal(@name_composit)
      end

      it "should redirect to the name_composit" do
        do_put
        response.should redirect_to(name_composit_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @name_composit.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /name_composits/1" do

    before(:each) do
      @name_composit = mock_model(NameComposit, :destroy => true)
      NameComposit.stub!(:find).and_return(@name_composit)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the name_composit requested" do
      NameComposit.should_receive(:find).with("1").and_return(@name_composit)
      do_delete
    end
  
    it "should call destroy on the found name_composit" do
      @name_composit.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the name_composits list" do
      do_delete
      response.should redirect_to(name_composits_url)
    end
  end
end
