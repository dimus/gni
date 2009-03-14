require 'gna_xml'

class DataSourcesController < ApplicationController
  before_filter :prepare_params, :only => [:create, :update]
  # GET /data_sources
  # GET /data_sources.xml
  def index
    if params.key? :name_string_id
      @data_sources = DataSource.find_by_sql("select ds.* from data_sources ds join name_indices ni on ds.id = ni.data_source_id where ni.name_string_id = #{params[:name_string_id]}")
    else
      @data_sources = DataSource.find(:all)
    end
    
    if current_user
      @user = User.find(current_user.id)
      @user_data_sources = @user.data_sources 
      #@active_schedulers = ImportScheduler.find(:all, :conditions => ["data_source_id in (?) and status != 'updated'", @data_soucres.map {|ds| ds.id}.join("'")]
    end

    if params[:user_id]
      @data_sources = User.find(params[:user_id]).data_sources
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_sources }
      format.json { render :json => @data_sources }
    end
  end

  # GET /data_sources/1
  # GET /data_sources/1.xml
  def show
    @data_source = DataSource.find(params[:id])
    @current_status = ImportScheduler.current_status(@data_source)
    @deleted = DataSourceImport.find(:first, :conditions => ["data_source_id = ? and name='delete'", @data_source.id], :order => 'updated_at desc') 
    @inserted = DataSourceImport.find(:first, :conditions => ["data_source_id = ? and name='insert'", @data_source.id], :order => 'updated_at desc')
    @updated = DataSourceImport.find(:first, :conditions => ["data_source_id = ? and name='update'", @data_source.id], :order => 'updated_at desc')

    @deleted_size = @deleted.data_source_import_details.size rescue 0
    @inserted_size = @inserted.data_source_import_details.size rescue 0 
    @updated_size = @updated.data_source_import_details.size rescue 0
    @last_import_scheduler = ImportScheduler.find(:first,:conditions => ["data_source_id = ?", @data_source.id], :order => "created_at desc") 
    @import_scheduler = ImportScheduler.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @data_source }
    end
  end

  # GET /data_sources/new
  # GET /data_sources/new.xml
  def new
    if current_user
      @data_source = DataSource.new
    
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @data_source }
      end
    else
      flash[:error] = 'Login or Sign In first before creating new repositories'
      redirect_to data_sources_url
    end
  end

  # GET /data_sources/1/edit
  def edit
    @data_source = DataSource.find(params[:id])

    if !(admin? || @data_source.contributor?(current_user))
      flash[:notice] = 'You are not a contributor for this source'
      redirect_to data_sources_url
    end  
  end

  # POST /data_sources
  # POST /data_sources.xml
  def create
    created_msg = "Repository was successfully created."
    @data_source = DataSource.new(params[:data_source])
    if current_user
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
    else
      render :text => '' #should never happen unless someone tries to hack the system
    end
  end

  # PUT /data_sources/1
  # PUT /data_sources/1.xml
  def update
    @data_source = DataSource.find(params[:id])
    if (admin? || @data_source.contributor?(current_user))
      respond_to do |format|
        if @data_source.update_attributes(params[:data_source])
          flash[:notice] = 'Repository was successfully updated.'
          format.html { redirect_to(@data_source) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @data_source.errors, :status => :unprocessable_entity }
        end
      end
    else
      render :text => '' #should never happen
    end
  end

  # DELETE /data_sources/1
  # DELETE /data_sources/1.xml
  def destroy
    @data_source = DataSource.find(params[:id])
    if (admin? || @data_source.contributor?(current_user))
      @data_source.destroy
      respond_to do |format|
        format.html { redirect_to(data_sources_url) }
        format.xml  { head :ok }
      end
    else
      render :text => '' #should never happen
    end
  end

protected
  def prepare_params
    %w(data_url logo_url web_site_url).each do |p|
      params[:data_source][p] = '' if params[:data_source][p] == "http://"
    end
  end
end
