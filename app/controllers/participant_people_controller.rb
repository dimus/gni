class ParticipantPeopleController < ApplicationController
  # GET /participant_people
  # GET /participant_people.xml
  def index
    @participant_people = ParticipantPerson.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participant_people }
    end
  end

  # GET /participant_people/1
  # GET /participant_people/1.xml
  def show
    @participant = ParticipantPerson.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participant }
    end
  end

  # GET /participant_people/new
  # GET /participant_people/new.xml
  def new
    @participant = ParticipantPerson.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participant }
    end
  end

  # GET /participant_people/1/edit
  def edit
    @participant = ParticipantPerson.find(params[:id])
  end

  # POST /participant_people
  # POST /participant_people.xml
  def create
    @participant = ParticipantPerson.new(params[:participant])

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

  # PUT /participant_people/1
  # PUT /participant_people/1.xml
  def update
    @participant = ParticipantPerson.find(params[:id])

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

  # DELETE /participant_people/1
  # DELETE /participant_people/1.xml
  def destroy
    @participant = ParticipantPerson.find(params[:id])
    @participant.destroy

    respond_to do |format|
      format.html { redirect_to(participant_people_url) }
      format.xml  { head :ok }
    end
  end
end
