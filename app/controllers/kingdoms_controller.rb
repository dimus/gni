class KingdomsController < ApplicationController
  # GET /kingdoms
  # GET /kingdoms.xml
  def index
    @kingdoms = Kingdom.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @kingdoms }
    end
  end

  # GET /kingdoms/1
  # GET /kingdoms/1.xml
  def show
    @kingdom = Kingdom.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @kingdom }
    end
  end

  # GET /kingdoms/new
  # GET /kingdoms/new.xml
  def new
    @kingdom = Kingdom.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @kingdom }
    end
  end

  # GET /kingdoms/1/edit
  def edit
    @kingdom = Kingdom.find(params[:id])
  end

  # POST /kingdoms
  # POST /kingdoms.xml
  def create
    @kingdom = Kingdom.new(params[:kingdom])

    respond_to do |format|
      if @kingdom.save
        flash[:notice] = 'Kingdom was successfully created.'
        format.html { redirect_to(@kingdom) }
        format.xml  { render :xml => @kingdom, :status => :created, :location => @kingdom }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kingdom.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /kingdoms/1
  # PUT /kingdoms/1.xml
  def update
    @kingdom = Kingdom.find(params[:id])

    respond_to do |format|
      if @kingdom.update_attributes(params[:kingdom])
        flash[:notice] = 'Kingdom was successfully updated.'
        format.html { redirect_to(@kingdom) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @kingdom.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /kingdoms/1
  # DELETE /kingdoms/1.xml
  def destroy
    @kingdom = Kingdom.find(params[:id])
    @kingdom.destroy

    respond_to do |format|
      format.html { redirect_to(kingdoms_url) }
      format.xml  { head :ok }
    end
  end
end
