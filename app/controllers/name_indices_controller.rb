class NameIndicesController < ApplicationController
  # GET /name_indices
  # GET /name_indices.xml
  def index
    @name_indices = NameIndex.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_indices }
    end
  end

  # GET /name_indices/1
  # GET /name_indices/1.xml
  def show
    @name_index = NameIndex.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_index }
    end
  end

  # GET /name_indices/new
  # GET /name_indices/new.xml
  def new
    @name_index = NameIndex.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_index }
    end
  end

  # GET /name_indices/1/edit
  def edit
    @name_index = NameIndex.find(params[:id])
  end

  # POST /name_indices
  # POST /name_indices.xml
  def create
    @name_index = NameIndex.new(params[:name_index])

    respond_to do |format|
      if @name_index.save
        flash[:notice] = 'NameIndex was successfully created.'
        format.html { redirect_to(@name_index) }
        format.xml  { render :xml => @name_index, :status => :created, :location => @name_index }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @name_index.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /name_indices/1
  # PUT /name_indices/1.xml
  def update
    @name_index = NameIndex.find(params[:id])

    respond_to do |format|
      if @name_index.update_attributes(params[:name_index])
        flash[:notice] = 'NameIndex was successfully updated.'
        format.html { redirect_to(@name_index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_index.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_indices/1
  # DELETE /name_indices/1.xml
  def destroy
    @name_index = NameIndex.find(params[:id])
    @name_index.destroy

    respond_to do |format|
      format.html { redirect_to(name_indices_url) }
      format.xml  { head :ok }
    end
  end
end
