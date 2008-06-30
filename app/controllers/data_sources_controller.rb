require 'gna_xml'

class DataSourcesController < ApplicationController
  # GET /data_sources
  # GET /data_sources.xml
  def index
    @data_sources = DataSource.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_sources }
    end
  end

  # GET /data_sources/1
  # GET /data_sources/1.xml
  def show
    @data_source = DataSource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @data_source }
    end
  end

  # GET /data_sources/new
  # GET /data_sources/new.xml
  def new
    @data_source = DataSource.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @data_source }
    end
  end

  # GET /data_sources/1/edit
  def edit
    @data_source = DataSource.find(params[:id])
    if !(admin? || @data_source.contributor?(current_user))
      flash[:notice] = 'Not a contributor for this source'
      redirect_to data_sources_url
    end  
  end

  # POST /data_sources
  # POST /data_sources.xml
  def create
    created_msg = "DataSource was successfully created."
    #if metadata_url exists get data from url
    if params[:data_source][:metadata_url]
      params[:data_source] = GNA_XML::data_source_xml(params[:data_source][:metadata_url])
      created_msg = created_msg[0...-1] + " using remote xml."
    end
    
    #TODO Make adding DataSourceController less failproof
    @data_source = DataSource.new(params[:data_source])
    respond_to do |format|
      if @data_source.save  
          DataSourceContributor.create({:data_source => @data_source, :user => current_user}) if current_user
          flash[:notice] = created_msg
          format.html { redirect_to(@data_source) }
          format.xml  { render :xml => @data_source, :status => :created, :location => @data_source }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @data_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /data_sources/1
  # PUT /data_sources/1.xml
  def update
    @data_source = DataSource.find(params[:id])

    respond_to do |format|
      if @data_source.update_attributes(params[:data_source])
        flash[:notice] = 'DataSource was successfully updated.'
        format.html { redirect_to(@data_source) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @data_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /data_sources/1
  # DELETE /data_sources/1.xml
  def destroy
    @data_source = DataSource.find(params[:id])
    @data_source.destroy

    respond_to do |format|
      format.html { redirect_to(data_sources_url) }
      format.xml  { head :ok }
    end
  end
end
