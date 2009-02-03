class DataSourceContributorsController < ApplicationController
  # GET /users/2/data_source_contributors
  # GET /users/2/data_source_contributors.xml
  def index
    @contributor = User.find(params[:user_id])
    @data_source_contributors = @contributor.data_source_contributors
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_source_contributors }
    end
  end

  # GET /data_source_contributors/1
  # GET /data_source_contributors/1.xml
  def show
    @data_source_contributor = DataSourceContributor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @data_source_contributor }
    end
  end

  # GET /data_source_contributors/new
  # GET /data_source_contributors/new.xml
  def new
    @data_source_contributor = DataSourceContributor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @data_source_contributor }
    end
  end

  # GET /data_source_contributors/1/edit
  def edit
    @data_source_contributor = DataSourceContributor.find(params[:id])
  end

  # POST /data_source_contributors
  # POST /data_source_contributors.xml
  def create
    @data_source_contributor = DataSourceContributor.new(params[:data_source_contributor])

    respond_to do |format|
      if @data_source_contributor.save
        flash[:notice] = 'DataSourceContributor was successfully created.'
        format.html { redirect_to(@data_source_contributor) }
        format.xml  { render :xml => @data_source_contributor, :status => :created, :location => @data_source_contributor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @data_source_contributor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /data_source_contributors/1
  # PUT /data_source_contributors/1.xml
  def update
    @data_source_contributor = DataSourceContributor.find(params[:id])

    respond_to do |format|
      if @data_source_contributor.update_attributes(params[:data_source_contributor])
        flash[:notice] = 'DataSourceContributor was successfully updated.'
        format.html { redirect_to(@data_source_contributor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @data_source_contributor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /data_source_contributors/1
  # DELETE /data_source_contributors/1.xml
  def destroy
    @data_source_contributor = DataSourceContributor.find(params[:id])
    @data_source_contributor.destroy

    respond_to do |format|
      format.html { redirect_to(data_source_contributors_url) }
      format.xml  { head :ok }
    end
  end
end
