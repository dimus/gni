class AccessTypesController < ApplicationController
  # GET /access_types
  # GET /access_types.xml
  def index
    @access_types = AccessType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @access_types }
    end
  end

  # GET /access_types/1
  # GET /access_types/1.xml
  def show
    @access_type = AccessType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @access_type }
    end
  end

  # GET /access_types/new
  # GET /access_types/new.xml
  def new
    @access_type = AccessType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @access_type }
    end
  end

  # GET /access_types/1/edit
  def edit
    @access_type = AccessType.find(params[:id])
  end

  # POST /access_types
  # POST /access_types.xml
  def create
    @access_type = AccessType.new(params[:access_type])

    respond_to do |format|
      if @access_type.save
        flash[:notice] = 'AccessType was successfully created.'
        format.html { redirect_to(@access_type) }
        format.xml  { render :xml => @access_type, :status => :created, :location => @access_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @access_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /access_types/1
  # PUT /access_types/1.xml
  def update
    @access_type = AccessType.find(params[:id])

    respond_to do |format|
      if @access_type.update_attributes(params[:access_type])
        flash[:notice] = 'AccessType was successfully updated.'
        format.html { redirect_to(@access_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @access_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /access_types/1
  # DELETE /access_types/1.xml
  def destroy
    @access_type = AccessType.find(params[:id])
    @access_type.destroy

    respond_to do |format|
      format.html { redirect_to(access_types_url) }
      format.xml  { head :ok }
    end
  end
end
