class DataProviderRolesController < ApplicationController
  # GET /data_provider_roles
  # GET /data_provider_roles.xml
  def index
    @data_provider_roles = DataProviderRole.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_provider_roles }
    end
  end

  # GET /data_provider_roles/1
  # GET /data_provider_roles/1.xml
  def show
    @data_provider_role = DataProviderRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @data_provider_role }
    end
  end

  # GET /data_provider_roles/new
  # GET /data_provider_roles/new.xml
  def new
    @data_provider_role = DataProviderRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @data_provider_role }
    end
  end

  # GET /data_provider_roles/1/edit
  def edit
    @data_provider_role = DataProviderRole.find(params[:id])
  end

  # POST /data_provider_roles
  # POST /data_provider_roles.xml
  def create
    @data_provider_role = DataProviderRole.new(params[:data_provider_role])

    respond_to do |format|
      if @data_provider_role.save
        flash[:notice] = 'DataProviderRole was successfully created.'
        format.html { redirect_to(@data_provider_role) }
        format.xml  { render :xml => @data_provider_role, :status => :created, :location => @data_provider_role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @data_provider_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /data_provider_roles/1
  # PUT /data_provider_roles/1.xml
  def update
    @data_provider_role = DataProviderRole.find(params[:id])

    respond_to do |format|
      if @data_provider_role.update_attributes(params[:data_provider_role])
        flash[:notice] = 'DataProviderRole was successfully updated.'
        format.html { redirect_to(@data_provider_role) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @data_provider_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /data_provider_roles/1
  # DELETE /data_provider_roles/1.xml
  def destroy
    @data_provider_role = DataProviderRole.find(params[:id])
    @data_provider_role.destroy

    respond_to do |format|
      format.html { redirect_to(data_provider_roles_url) }
      format.xml  { head :ok }
    end
  end
end
