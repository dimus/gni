class ParticipantOrganizationsController < ApplicationController
  # GET /participant_organizations
  # GET /participant_organizations.xml
  def index
    @participants = ParticipantOrganization.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participants }
    end
  end

  # GET /participant_organizations/1
  # GET /participant_organizations/1.xml
  def show
    @participant = ParticipantOrganization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participant }
    end
  end

  # GET /participant_organizations/new
  # GET /participant_organizations/new.xml
  def new
    @participant = ParticipantOrganization.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participant }
    end
  end

  # GET /participant_organizations/1/edit
  def edit
    @participant = ParticipantOrganization.find(params[:id])
  end

  # POST /participant_organizations
  # POST /participant_organizations.xml
  def create
    @participant = ParticipantOrganization.new(params[:participant])

    respond_to do |format|
      if @participant.save
        flash[:notice] = 'Participant was successfully created.'
        format.html { redirect_to(@participant) }
        format.xml  { render :xml => @participant, :status => :created, :location => @participant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /participant_organizations/1
  # PUT /participant_organizations/1.xml
  def update
    @participant = ParticipantOrganization.find(params[:id])

    respond_to do |format|
      if @participant.update_attributes(params[:participant])
        flash[:notice] = 'Participant was successfully updated.'
        format.html { redirect_to(@participant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /participant_organizations/1
  # DELETE /participant_organizations/1.xml
  def destroy
    @participant = ParticipantOrganization.find(params[:id])
    @participant.destroy

    respond_to do |format|
      format.html { redirect_to(participants_url) }
      format.xml  { head :ok }
    end
  end
end
