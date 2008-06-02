class AccessRulesController < ApplicationController
  layout application
  # GET /access_rules
  # GET /access_rules.xml
  def index
    @access_rules = AccessRule.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @access_rules }
    end
  end

  # GET /access_rules/1
  # GET /access_rules/1.xml
  def show
    @access_rule = AccessRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @access_rule }
    end
  end

  # GET /access_rules/new
  # GET /access_rules/new.xml
  def new
    @access_rule = AccessRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @access_rule }
    end
  end

  # GET /access_rules/1/edit
  def edit
    @access_rule = AccessRule.find(params[:id])
  end

  # POST /access_rules
  # POST /access_rules.xml
  def create
    @access_rule = AccessRule.new(params[:access_rule])

    respond_to do |format|
      if @access_rule.save
        flash[:notice] = 'AccessRule was successfully created.'
        format.html { redirect_to(@access_rule) }
        format.xml  { render :xml => @access_rule, :status => :created, :location => @access_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @access_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /access_rules/1
  # PUT /access_rules/1.xml
  def update
    @access_rule = AccessRule.find(params[:id])

    respond_to do |format|
      if @access_rule.update_attributes(params[:access_rule])
        flash[:notice] = 'AccessRule was successfully updated.'
        format.html { redirect_to(@access_rule) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @access_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /access_rules/1
  # DELETE /access_rules/1.xml
  def destroy
    @access_rule = AccessRule.find(params[:id])
    @access_rule.destroy

    respond_to do |format|
      format.html { redirect_to(access_rules_url) }
      format.xml  { head :ok }
    end
  end
end
