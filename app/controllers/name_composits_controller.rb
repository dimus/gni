class NameCompositsController < ApplicationController
  # GET /name_composits
  # GET /name_composits.xml
  def index
    @name_composits = NameComposit.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_composits }
    end
  end

  # GET /name_composits/1
  # GET /name_composits/1.xml
  def show
    @name_composit = NameComposit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_composit }
    end
  end

  # GET /name_composits/new
  # GET /name_composits/new.xml
  def new
    @name_composit = NameComposit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_composit }
    end
  end

  # GET /name_composits/1/edit
  def edit
    @name_composit = NameComposit.find(params[:id])
  end

  # POST /name_composits
  # POST /name_composits.xml
  def create
    @name_composit = NameComposit.new(params[:name_composit])

    respond_to do |format|
      if @name_composit.save
        flash[:notice] = 'NameComposit was successfully created.'
        format.html { redirect_to(@name_composit) }
        format.xml  { render :xml => @name_composit, :status => :created, :location => @name_composit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @name_composit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /name_composits/1
  # PUT /name_composits/1.xml
  def update
    @name_composit = NameComposit.find(params[:id])

    respond_to do |format|
      if @name_composit.update_attributes(params[:name_composit])
        flash[:notice] = 'NameComposit was successfully updated.'
        format.html { redirect_to(@name_composit) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_composit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_composits/1
  # DELETE /name_composits/1.xml
  def destroy
    @name_composit = NameComposit.find(params[:id])
    @name_composit.destroy

    respond_to do |format|
      format.html { redirect_to(name_composits_url) }
      format.xml  { head :ok }
    end
  end
end
