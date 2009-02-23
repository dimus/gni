class DataSourceOverlapsController < ApplicationController
  # GET /data_source_overlaps
  # GET /data_source_overlaps.xml
  def index
    page = params[:page] || 1 rescue 1
    @data_source = DataSource.find params[:data_source_id]
    @data_source_overlaps = DataSourceOverlaps.paginate_by_sql(["select data_source_id_1, data_source_id_2, strict_overlap, (strict_overlap/?) * 100 as percentage from data_source_overlaps where data_source_id_1 = ? order by percentage desc", @data_source.name_indices.size,  @data_source.id], :order => "percentage desc", :page => page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @data_source_overlaps }
    end
  end

  # GET /data_source_overlaps/1
  # GET /data_source_overlaps/1.xml
  def show
    @data_source_overlaps = DataSourceOverlaps.find_by_data_source_id_1(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @data_source_overlaps }
    end
  end

  # GET /data_source_overlaps/new
  # GET /data_source_overlaps/new.xml
  def new
    @data_source_overlaps = DataSourceOverlaps.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @data_source_overlaps }
    end
  end

  # GET /data_source_overlaps/1/edit
  def edit
    @data_source_overlaps = DataSourceOverlaps.find(params[:id])
  end

  # POST /data_source_overlaps
  # POST /data_source_overlaps.xml
  def create
    @data_source_overlaps = DataSourceOverlaps.new(params[:data_source_overlaps])

    respond_to do |format|
      if @data_source_overlaps.save
        flash[:notice] = 'DataSourceOverlaps was successfully created.'
        format.html { redirect_to(@data_source_overlaps) }
        format.xml  { render :xml => @data_source_overlaps, :status => :created, :location => @data_source_overlaps }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @data_source_overlaps.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /data_source_overlaps/1
  # PUT /data_source_overlaps/1.xml
  def update
    @data_source_overlaps = DataSourceOverlaps.find(params[:id])

    respond_to do |format|
      if @data_source_overlaps.update_attributes(params[:data_source_overlaps])
        flash[:notice] = 'DataSourceOverlaps was successfully updated.'
        format.html { redirect_to(@data_source_overlaps) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @data_source_overlaps.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /data_source_overlaps/1
  # DELETE /data_source_overlaps/1.xml
  def destroy
    @data_source_overlaps = DataSourceOverlaps.find(params[:id])
    @data_source_overlaps.destroy

    respond_to do |format|
      format.html { redirect_to(data_source_overlaps_url) }
      format.xml  { head :ok }
    end
  end
end
