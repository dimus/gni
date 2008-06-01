class ParticipantsController < ApplicationController
  # GET /participants
  # GET /participants.xml
  def index
    @participants = Participant.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participants }
    end
  end
end
