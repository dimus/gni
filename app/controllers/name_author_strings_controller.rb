class NameAuthorStringsController < ApplicationController
  # GET /name_author_strings
  # GET /name_author_strings.xml
  def index
    @name_author_strings = NameAuthorString.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_author_strings }
    end
  end

  # GET /name_author_strings/1
  # GET /name_author_strings/1.xml
  def show
    @name_author_string = NameAuthorString.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_author_string }
    end
  end

  # GET /name_author_strings/new
  # GET /name_author_strings/new.xml
  def new
    @name_author_string = NameAuthorString.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_author_string }
    end
  end

  # GET /name_author_strings/1/edit
  def edit
    @name_author_string = NameAuthorString.find(params[:id])
  end

  # POST /name_author_strings
  # POST /name_author_strings.xml
  def create
    @name_author_string = NameAuthorString.new(params[:name_author_string])

    respond_to do |format|
      if @name_author_string.save
        flash[:notice] = 'NameAuthorString was successfully created.'
        format.html { redirect_to(@name_author_string) }
        format.xml  { render :xml => @name_author_string, :status => :created, :location => @name_author_string }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @name_author_string.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /name_author_strings/1
  # PUT /name_author_strings/1.xml
  def update
    @name_author_string = NameAuthorString.find(params[:id])

    respond_to do |format|
      if @name_author_string.update_attributes(params[:name_author_string])
        flash[:notice] = 'NameAuthorString was successfully updated.'
        format.html { redirect_to(@name_author_string) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_author_string.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_author_strings/1
  # DELETE /name_author_strings/1.xml
  def destroy
    @name_author_string = NameAuthorString.find(params[:id])
    @name_author_string.destroy

    respond_to do |format|
      format.html { redirect_to(name_author_strings_url) }
      format.xml  { head :ok }
    end
  end
end
