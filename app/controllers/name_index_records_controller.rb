class NameIndexRecordsController < ApplicationController
  # GET /name_index_records
  # GET /name_index_records.xml
  def index
    @name_index_records = NameIndexRecord.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_index_records }
    end
  end

  # GET /name_index_records/1
  # GET /name_index_records/1.xml
  def show
    @name_index_record = NameIndexRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_index_record }
    end
  end

  # GET /name_index_records/new
  # GET /name_index_records/new.xml
  def new
    @name_index_record = NameIndexRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_index_record }
    end
  end

  # GET /name_index_records/1/edit
  def edit
    @name_index_record = NameIndexRecord.find(params[:id])
  end

  # POST /name_index_records
  # POST /name_index_records.xml
  def create
    @name_index_record = NameIndexRecord.new(params[:name_index_record])

    respond_to do |format|
      if @name_index_record.save
        flash[:notice] = 'NameIndexRecord was successfully created.'
        format.html { redirect_to(@name_index_record) }
        format.xml  { render :xml => @name_index_record, :status => :created, :location => @name_index_record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @name_index_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /name_index_records/1
  # PUT /name_index_records/1.xml
  def update
    @name_index_record = NameIndexRecord.find(params[:id])

    respond_to do |format|
      if @name_index_record.update_attributes(params[:name_index_record])
        flash[:notice] = 'NameIndexRecord was successfully updated.'
        format.html { redirect_to(@name_index_record) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_index_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_index_records/1
  # DELETE /name_index_records/1.xml
  def destroy
    @name_index_record = NameIndexRecord.find(params[:id])
    @name_index_record.destroy

    respond_to do |format|
      format.html { redirect_to(name_index_records_url) }
      format.xml  { head :ok }
    end
  end
end
