class ResponseFormatsController < ApplicationController
  # GET /response_formats
  # GET /response_formats.xml
  def index
    @response_formats = ResponseFormat.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @response_formats }
    end
  end

  # GET /response_formats/1
  # GET /response_formats/1.xml
  def show
    @response_format = ResponseFormat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @response_format }
    end
  end

  # GET /response_formats/new
  # GET /response_formats/new.xml
  def new
    @response_format = ResponseFormat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @response_format }
    end
  end

  # GET /response_formats/1/edit
  def edit
    @response_format = ResponseFormat.find(params[:id])
  end

  # POST /response_formats
  # POST /response_formats.xml
  def create
    @response_format = ResponseFormat.new(params[:response_format])

    respond_to do |format|
      if @response_format.save
        flash[:notice] = 'ResponseFormat was successfully created.'
        format.html { redirect_to(@response_format) }
        format.xml  { render :xml => @response_format, :status => :created, :location => @response_format }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @response_format.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /response_formats/1
  # PUT /response_formats/1.xml
  def update
    @response_format = ResponseFormat.find(params[:id])

    respond_to do |format|
      if @response_format.update_attributes(params[:response_format])
        flash[:notice] = 'ResponseFormat was successfully updated.'
        format.html { redirect_to(@response_format) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @response_format.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /response_formats/1
  # DELETE /response_formats/1.xml
  def destroy
    @response_format = ResponseFormat.find(params[:id])
    @response_format.destroy

    respond_to do |format|
      format.html { redirect_to(response_formats_url) }
      format.xml  { head :ok }
    end
  end
end
