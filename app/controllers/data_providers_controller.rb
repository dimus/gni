class DataProvidersController < ApplicationController
  # GET /data_providers
  # GET /data_providers.xml
  def index
    @data_providers = DataProvider.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_providers }
    end
  end

  # GET /data_providers/1
  # GET /data_providers/1.xml
  def show
    @data_provider = DataProvider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @data_provider }
    end
  end

  # GET /data_providers/new
  # GET /data_providers/new.xml
  def new
    @data_provider = DataProvider.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @data_provider }
    end
  end

  # GET /data_providers/1/edit
  def edit
    @data_provider = DataProvider.find(params[:id])
  end

  # POST /data_providers
  # POST /data_providers.xml
  def create
    @data_provider = DataProvider.new(params[:data_provider])

    respond_to do |format|
      if @data_provider.save
        flash[:notice] = 'DataProvider was successfully created.'
        format.html { redirect_to(@data_provider) }
        format.xml  { render :xml => @data_provider, :status => :created, :location => @data_provider }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @data_provider.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /data_providers/1
  # PUT /data_providers/1.xml
  def update
    @data_provider = DataProvider.find(params[:id])

    respond_to do |format|
      if @data_provider.update_attributes(params[:data_provider])
        flash[:notice] = 'DataProvider was successfully updated.'
        format.html { redirect_to(@data_provider) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @data_provider.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /data_providers/1
  # DELETE /data_providers/1.xml
  def destroy
    @data_provider = DataProvider.find(params[:id])
    @data_provider.destroy

    respond_to do |format|
      format.html { redirect_to(data_providers_url) }
      format.xml  { head :ok }
    end
  end
end
