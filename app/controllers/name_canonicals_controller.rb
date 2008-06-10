class NameCanonicalsController < ApplicationController
  # GET /name_canonicals
  # GET /name_canonicals.xml
  def index
    @name_canonicals = NameCanonical.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @name_canonicals }
    end
  end

  # GET /name_canonicals/1
  # GET /name_canonicals/1.xml
  def show
    @name_canonical = NameCanonical.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @name_canonical }
    end
  end

  # GET /name_canonicals/new
  # GET /name_canonicals/new.xml
  def new
    @name_canonical = NameCanonical.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @name_canonical }
    end
  end

  # GET /name_canonicals/1/edit
  def edit
    @name_canonical = NameCanonical.find(params[:id])
  end

  # POST /name_canonicals
  # POST /name_canonicals.xml
  def create
    @name_canonical = NameCanonical.new(params[:name_canonical])

    respond_to do |format|
      if @name_canonical.save
        flash[:notice] = 'NameCanonical was successfully created.'
        format.html { redirect_to(@name_canonical) }
        format.xml  { render :xml => @name_canonical, :status => :created, :location => @name_canonical }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @name_canonical.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /name_canonicals/1
  # PUT /name_canonicals/1.xml
  def update
    @name_canonical = NameCanonical.find(params[:id])

    respond_to do |format|
      if @name_canonical.update_attributes(params[:name_canonical])
        flash[:notice] = 'NameCanonical was successfully updated.'
        format.html { redirect_to(@name_canonical) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @name_canonical.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /name_canonicals/1
  # DELETE /name_canonicals/1.xml
  def destroy
    @name_canonical = NameCanonical.find(params[:id])
    @name_canonical.destroy

    respond_to do |format|
      format.html { redirect_to(name_canonicals_url) }
      format.xml  { head :ok }
    end
  end
end
