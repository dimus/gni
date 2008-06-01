class ParticipantContactsController < ApplicationController
  # GET /participant_contacts
  # GET /participant_contacts.xml
  def index
    @participant_contacts = ParticipantContact.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participant_contacts }
    end
  end

  # GET /participant_contacts/1
  # GET /participant_contacts/1.xml
  def show
    @participant_contact = ParticipantContact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participant_contact }
    end
  end

  # GET /participant_contacts/new
  # GET /participant_contacts/new.xml
  def new
    @participant_contact = ParticipantContact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participant_contact }
    end
  end

  # GET /participant_contacts/1/edit
  def edit
    @participant_contact = ParticipantContact.find(params[:id])
  end

  # POST /participant_contacts
  # POST /participant_contacts.xml
  def create
    @participant_contact = ParticipantContact.new(params[:participant_contact])

    respond_to do |format|
      if @participant_contact.save
        flash[:notice] = 'ParticipantContact was successfully created.'
        format.html { redirect_to(@participant_contact) }
        format.xml  { render :xml => @participant_contact, :status => :created, :location => @participant_contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @participant_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /participant_contacts/1
  # PUT /participant_contacts/1.xml
  def update
    @participant_contact = ParticipantContact.find(params[:id])

    respond_to do |format|
      if @participant_contact.update_attributes(params[:participant_contact])
        flash[:notice] = 'ParticipantContact was successfully updated.'
        format.html { redirect_to(@participant_contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participant_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /participant_contacts/1
  # DELETE /participant_contacts/1.xml
  def destroy
    @participant_contact = ParticipantContact.find(params[:id])
    @participant_contact.destroy

    respond_to do |format|
      format.html { redirect_to(participant_contacts_url) }
      format.xml  { head :ok }
    end
  end
end
