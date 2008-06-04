class UriTypesController < ApplicationController
  # GET /uri_types
  # GET /uri_types.xml
  def index
    @uri_types = UriType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @uri_types }
    end
  end

  # GET /uri_types/1
  # GET /uri_types/1.xml
  def show
    @uri_type = UriType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @uri_type }
    end
  end

  # GET /uri_types/new
  # GET /uri_types/new.xml
  def new
    @uri_type = UriType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @uri_type }
    end
  end

  # GET /uri_types/1/edit
  def edit
    @uri_type = UriType.find(params[:id])
  end

  # POST /uri_types
  # POST /uri_types.xml
  def create
    @uri_type = UriType.new(params[:uri_type])

    respond_to do |format|
      if @uri_type.save
        flash[:notice] = 'UriType was successfully created.'
        format.html { redirect_to(@uri_type) }
        format.xml  { render :xml => @uri_type, :status => :created, :location => @uri_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @uri_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /uri_types/1
  # PUT /uri_types/1.xml
  def update
    @uri_type = UriType.find(params[:id])

    respond_to do |format|
      if @uri_type.update_attributes(params[:uri_type])
        flash[:notice] = 'UriType was successfully updated.'
        format.html { redirect_to(@uri_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @uri_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /uri_types/1
  # DELETE /uri_types/1.xml
  def destroy
    @uri_type = UriType.find(params[:id])
    @uri_type.destroy

    respond_to do |format|
      format.html { redirect_to(uri_types_url) }
      format.xml  { head :ok }
    end
  end
end
