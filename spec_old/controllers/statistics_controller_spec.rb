require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StatisticsController do
  describe "handling GET /statistics" do

    before(:each) do
      @statistic = mock_model(Statistic)
      Statistic.stub!(:find).and_return([@statistic])
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
  
    it "should find all statistics" do
      Statistic.should_receive(:find).with(:all).and_return([@statistic])
      do_get
    end
  
    it "should assign the found statistics for the view" do
      do_get
      assigns[:statistics].should == [@statistic]
    end
  end

  describe "handling GET /statistics.xml" do

    before(:each) do
      @statistics = mock("Array of Statistics", :to_xml => "XML")
      Statistic.stub!(:find).and_return(@statistics)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all statistics" do
      Statistic.should_receive(:find).with(:all).and_return(@statistics)
      do_get
    end
  
    it "should render the found statistics as xml" do
      @statistics.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /statistics/1" do

    before(:each) do
      @statistic = mock_model(Statistic)
      Statistic.stub!(:find).and_return(@statistic)
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
  
    it "should find the statistic requested" do
      Statistic.should_receive(:find).with("1").and_return(@statistic)
      do_get
    end
  
    it "should assign the found statistic for the view" do
      do_get
      assigns[:statistic].should equal(@statistic)
    end
  end

  describe "handling GET /statistics/1.xml" do

    before(:each) do
      @statistic = mock_model(Statistic, :to_xml => "XML")
      Statistic.stub!(:find).and_return(@statistic)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the statistic requested" do
      Statistic.should_receive(:find).with("1").and_return(@statistic)
      do_get
    end
  
    it "should render the found statistic as xml" do
      @statistic.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /statistics/new" do

    before(:each) do
      @statistic = mock_model(Statistic)
      Statistic.stub!(:new).and_return(@statistic)
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
  
    it "should create an new statistic" do
      Statistic.should_receive(:new).and_return(@statistic)
      do_get
    end
  
    it "should not save the new statistic" do
      @statistic.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new statistic for the view" do
      do_get
      assigns[:statistic].should equal(@statistic)
    end
  end

  describe "handling GET /statistics/1/edit" do

    before(:each) do
      @statistic = mock_model(Statistic)
      Statistic.stub!(:find).and_return(@statistic)
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
  
    it "should find the statistic requested" do
      Statistic.should_receive(:find).and_return(@statistic)
      do_get
    end
  
    it "should assign the found Statistic for the view" do
      do_get
      assigns[:statistic].should equal(@statistic)
    end
  end

  describe "handling POST /statistics" do

    before(:each) do
      @statistic = mock_model(Statistic, :to_param => "1")
      Statistic.stub!(:new).and_return(@statistic)
    end
    
    describe "with successful save" do
  
      def do_post
        @statistic.should_receive(:save).and_return(true)
        post :create, :statistic => {}
      end
  
      it "should create a new statistic" do
        Statistic.should_receive(:new).with({}).and_return(@statistic)
        do_post
      end

      it "should redirect to the new statistic" do
        do_post
        response.should redirect_to(statistic_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @statistic.should_receive(:save).and_return(false)
        post :create, :statistic => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /statistics/1" do

    before(:each) do
      @statistic = mock_model(Statistic, :to_param => "1")
      Statistic.stub!(:find).and_return(@statistic)
    end
    
    describe "with successful update" do

      def do_put
        @statistic.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the statistic requested" do
        Statistic.should_receive(:find).with("1").and_return(@statistic)
        do_put
      end

      it "should update the found statistic" do
        do_put
        assigns(:statistic).should equal(@statistic)
      end

      it "should assign the found statistic for the view" do
        do_put
        assigns(:statistic).should equal(@statistic)
      end

      it "should redirect to the statistic" do
        do_put
        response.should redirect_to(statistic_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @statistic.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /statistics/1" do

    before(:each) do
      @statistic = mock_model(Statistic, :destroy => true)
      Statistic.stub!(:find).and_return(@statistic)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the statistic requested" do
      Statistic.should_receive(:find).with("1").and_return(@statistic)
      do_delete
    end
  
    it "should call destroy on the found statistic" do
      @statistic.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the statistics list" do
      do_delete
      response.should redirect_to(statistics_url)
    end
  end
end
