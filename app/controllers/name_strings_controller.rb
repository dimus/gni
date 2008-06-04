class NameStringsController < ApplicationController
  # GET /name_strings
  # GET /name_strings.xml
  def index
    @name_strings = NameString.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_strings }
    end
  end

  # GET /name_strings/1
  # GET /name_strings/1.xml
  def show
    @name_string = NameString.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_string }
    end
  end

  # GET /name_strings/new
  # GET /name_strings/new.xml
  def new
    @name_string = NameString.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_string }
    end
  end

  # GET /name_strings/1/edit
  def edit
    @name_string = NameString.find(params[:id])
  end

  # POST /name_strings
  # POST /name_strings.xml
  def create
    @name_string = NameString.new(params[:name_string])

    respond_to do |format|
      if @name_string.save
        flash[:notice] = 'NameString was successfully created.'
        format.html { redirect_to(@name_string) }
        format.xml  { render :xml => @name_string, :status => :created, :location => @name_string }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @name_string.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /name_strings/1
  # PUT /name_strings/1.xml
  def update
    @name_string = NameString.find(params[:id])

    respond_to do |format|
      if @name_string.update_attributes(params[:name_string])
        flash[:notice] = 'NameString was successfully updated.'
        format.html { redirect_to(@name_string) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_string.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_strings/1
  # DELETE /name_strings/1.xml
  def destroy
    @name_string = NameString.find(params[:id])
    @name_string.destroy

    respond_to do |format|
      format.html { redirect_to(name_strings_url) }
      format.xml  { head :ok }
    end
  end
end
