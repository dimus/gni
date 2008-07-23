require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameIndexRecordsController do
  describe "handling GET /name_index_records" do

    before(:each) do
      @name_index_record = mock_model(NameIndexRecord)
      NameIndexRecord.stub!(:find).and_return([@name_index_record])
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
  
    it "should find all name_index_records" do
      NameIndexRecord.should_receive(:find).with(:all).and_return([@name_index_record])
      do_get
    end
  
    it "should assign the found name_index_records for the view" do
      do_get
      assigns[:name_index_records].should == [@name_index_record]
    end
  end

  describe "handling GET /name_index_records.xml" do

    before(:each) do
      @name_index_records = mock("Array of NameIndexRecords", :to_xml => "XML")
      NameIndexRecord.stub!(:find).and_return(@name_index_records)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all name_index_records" do
      NameIndexRecord.should_receive(:find).with(:all).and_return(@name_index_records)
      do_get
    end
  
    it "should render the found name_index_records as xml" do
      @name_index_records.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_index_records/1" do

    before(:each) do
      @name_index_record = mock_model(NameIndexRecord)
      NameIndexRecord.stub!(:find).and_return(@name_index_record)
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
  
    it "should find the name_index_record requested" do
      NameIndexRecord.should_receive(:find).with("1").and_return(@name_index_record)
      do_get
    end
  
    it "should assign the found name_index_record for the view" do
      do_get
      assigns[:name_index_record].should equal(@name_index_record)
    end
  end

  describe "handling GET /name_index_records/1.xml" do

    before(:each) do
      @name_index_record = mock_model(NameIndexRecord, :to_xml => "XML")
      NameIndexRecord.stub!(:find).and_return(@name_index_record)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the name_index_record requested" do
      NameIndexRecord.should_receive(:find).with("1").and_return(@name_index_record)
      do_get
    end
  
    it "should render the found name_index_record as xml" do
      @name_index_record.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /name_index_records/new" do

    before(:each) do
      @name_index_record = mock_model(NameIndexRecord)
      NameIndexRecord.stub!(:new).and_return(@name_index_record)
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
  
    it "should create an new name_index_record" do
      NameIndexRecord.should_receive(:new).and_return(@name_index_record)
      do_get
    end
  
    it "should not save the new name_index_record" do
      @name_index_record.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new name_index_record for the view" do
      do_get
      assigns[:name_index_record].should equal(@name_index_record)
    end
  end

  describe "handling GET /name_index_records/1/edit" do

    before(:each) do
      @name_index_record = mock_model(NameIndexRecord)
      NameIndexRecord.stub!(:find).and_return(@name_index_record)
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
  
    it "should find the name_index_record requested" do
      NameIndexRecord.should_receive(:find).and_return(@name_index_record)
      do_get
    end
  
    it "should assign the found NameIndexRecord for the view" do
      do_get
      assigns[:name_index_record].should equal(@name_index_record)
    end
  end

  describe "handling POST /name_index_records" do

    before(:each) do
      @name_index_record = mock_model(NameIndexRecord, :to_param => "1")
      NameIndexRecord.stub!(:new).and_return(@name_index_record)
    end
    
    describe "with successful save" do
  
      def do_post
        @name_index_record.should_receive(:save).and_return(true)
        post :create, :name_index_record => {}
      end
  
      it "should create a new name_index_record" do
        NameIndexRecord.should_receive(:new).with({}).and_return(@name_index_record)
        do_post
      end

      it "should redirect to the new name_index_record" do
        do_post
        response.should redirect_to(name_index_record_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @name_index_record.should_receive(:save).and_return(false)
        post :create, :name_index_record => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /name_index_records/1" do

    before(:each) do
      @name_index_record = mock_model(NameIndexRecord, :to_param => "1")
      NameIndexRecord.stub!(:find).and_return(@name_index_record)
    end
    
    describe "with successful update" do

      def do_put
        @name_index_record.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the name_index_record requested" do
        NameIndexRecord.should_receive(:find).with("1").and_return(@name_index_record)
        do_put
      end

      it "should update the found name_index_record" do
        do_put
        assigns(:name_index_record).should equal(@name_index_record)
      end

      it "should assign the found name_index_record for the view" do
        do_put
        assigns(:name_index_record).should equal(@name_index_record)
      end

      it "should redirect to the name_index_record" do
        do_put
        response.should redirect_to(name_index_record_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @name_index_record.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /name_index_records/1" do

    before(:each) do
      @name_index_record = mock_model(NameIndexRecord, :destroy => true)
      NameIndexRecord.stub!(:find).and_return(@name_index_record)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the name_index_record requested" do
      NameIndexRecord.should_receive(:find).with("1").and_return(@name_index_record)
      do_delete
    end
  
    it "should call destroy on the found name_index_record" do
      @name_index_record.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the name_index_records list" do
      do_delete
      response.should redirect_to(name_index_records_url)
    end
  end
end
