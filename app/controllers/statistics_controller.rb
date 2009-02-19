class StatisticsController < ApplicationController
  # GET /statistics
  # GET /statistics.xml
  def index
    @statistics = Statistic.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statistics }
    end
  end

  # GET /statistics/1
  # GET /statistics/1.xml
  def show
    @statistic = Statistic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @statistic }
    end
  end

  # GET /statistics/new
  # GET /statistics/new.xml
  def new
    @statistic = Statistic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @statistic }
    end
  end

  # GET /statistics/1/edit
  def edit
    @statistic = Statistic.find(params[:id])
  end

  # POST /statistics
  # POST /statistics.xml
  def create
    @statistic = Statistic.new(params[:statistic])

    respond_to do |format|
      if @statistic.save
        flash[:notice] = 'Statistic was successfully created.'
        format.html { redirect_to(@statistic) }
        format.xml  { render :xml => @statistic, :status => :created, :location => @statistic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @statistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statistics/1
  # PUT /statistics/1.xml
  def update
    @statistic = Statistic.find(params[:id])

    respond_to do |format|
      if @statistic.update_attributes(params[:statistic])
        flash[:notice] = 'Statistic was successfully updated.'
        format.html { redirect_to(@statistic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @statistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statistics/1
  # DELETE /statistics/1.xml
  def destroy
    @statistic = Statistic.find(params[:id])
    @statistic.destroy

    respond_to do |format|
      format.html { redirect_to(statistics_url) }
      format.xml  { head :ok }
    end
  end
end
