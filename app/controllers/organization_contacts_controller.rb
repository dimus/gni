class OrganizationContactsController < ApplicationController
  # GET /organization_contacts
  # GET /organization_contacts.xml
  def index
    @organization_contacts = OrganizationContact.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organization_contacts }
    end
  end

  # GET /organization_contacts/1
  # GET /organization_contacts/1.xml
  def show
    @organization_contact = OrganizationContact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization_contact }
    end
  end

  # GET /organization_contacts/new
  # GET /organization_contacts/new.xml
  def new
    @organization_contact = OrganizationContact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization_contact }
    end
  end

  # GET /organization_contacts/1/edit
  def edit
    @organization_contact = OrganizationContact.find(params[:id])
  end

  # POST /organization_contacts
  # POST /organization_contacts.xml
  def create
    @organization_contact = OrganizationContact.new(params[:organization_contact])

    respond_to do |format|
      if @organization_contact.save
        flash[:notice] = 'OrganizationContact was successfully created.'
        format.html { redirect_to(@organization_contact) }
        format.xml  { render :xml => @organization_contact, :status => :created, :location => @organization_contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organization_contacts/1
  # PUT /organization_contacts/1.xml
  def update
    @organization_contact = OrganizationContact.find(params[:id])

    respond_to do |format|
      if @organization_contact.update_attributes(params[:organization_contact])
        flash[:notice] = 'OrganizationContact was successfully updated.'
        format.html { redirect_to(@organization_contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_contacts/1
  # DELETE /organization_contacts/1.xml
  def destroy
    @organization_contact = OrganizationContact.find(params[:id])
    @organization_contact.destroy

    respond_to do |format|
      format.html { redirect_to(organization_contacts_url) }
      format.xml  { head :ok }
    end
  end
end
