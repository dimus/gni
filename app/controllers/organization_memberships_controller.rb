class OrganizationMembershipsController < ApplicationController
  # GET /organization_memberships
  # GET /organization_memberships.xml
  def index
    @organization_memberships = OrganizationMembership.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organization_memberships }
    end
  end

  # GET /organization_memberships/1
  # GET /organization_memberships/1.xml
  def show
    @organization_membership = OrganizationMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization_membership }
    end
  end

  # GET /organization_memberships/new
  # GET /organization_memberships/new.xml
  def new
    @organization_membership = OrganizationMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization_membership }
    end
  end

  # GET /organization_memberships/1/edit
  def edit
    @organization_membership = OrganizationMembership.find(params[:id])
  end

  # POST /organization_memberships
  # POST /organization_memberships.xml
  def create
    @organization_membership = OrganizationMembership.new(params[:organization_membership])

    respond_to do |format|
      if @organization_membership.save
        flash[:notice] = 'OrganizationMembership was successfully created.'
        format.html { redirect_to(@organization_membership) }
        format.xml  { render :xml => @organization_membership, :status => :created, :location => @organization_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organization_memberships/1
  # PUT /organization_memberships/1.xml
  def update
    @organization_membership = OrganizationMembership.find(params[:id])

    respond_to do |format|
      if @organization_membership.update_attributes(params[:organization_membership])
        flash[:notice] = 'OrganizationMembership was successfully updated.'
        format.html { redirect_to(@organization_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_memberships/1
  # DELETE /organization_memberships/1.xml
  def destroy
    @organization_membership = OrganizationMembership.find(params[:id])
    @organization_membership.destroy

    respond_to do |format|
      format.html { redirect_to(organization_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
