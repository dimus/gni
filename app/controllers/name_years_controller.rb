class NameYearsController < ApplicationController
  # GET /name_years
  # GET /name_years.xml
  def index
    @name_years = NameYear.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_years }
    end
  end

  # GET /name_years/1
  # GET /name_years/1.xml
  def show
    @name_year = NameYear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_year }
    end
  end

  # GET /name_years/new
  # GET /name_years/new.xml
  def new
    @name_year = NameYear.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_year }
    end
  end

  # GET /name_years/1/edit
  def edit
    @name_year = NameYear.find(params[:id])
  end

  # POST /name_years
  # POST /name_years.xml
  def create
    @name_year = NameYear.new(params[:name_year])

    respond_to do |format|
      if @name_year.save
        flash[:notice] = 'NameYear was successfully created.'
        format.html { redirect_to(@name_year) }
        format.xml  { render :xml => @name_year, :status => :created, :location => @name_year }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @name_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /name_years/1
  # PUT /name_years/1.xml
  def update
    @name_year = NameYear.find(params[:id])

    respond_to do |format|
      if @name_year.update_attributes(params[:name_year])
        flash[:notice] = 'NameYear was successfully updated.'
        format.html { redirect_to(@name_year) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_years/1
  # DELETE /name_years/1.xml
  def destroy
    @name_year = NameYear.find(params[:id])
    @name_year.destroy

    respond_to do |format|
      format.html { redirect_to(name_years_url) }
      format.xml  { head :ok }
    end
  end
end
