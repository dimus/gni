class UsersController < ApplicationController

  # GET /users/new 
  # GET /users/new.xml
  def new
    @user = User.new
  end
 
  # POST /users 
  # POST /users.xml
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      #reset session
      respond_to do |wants|
        wants.html do
          self.current_user = @user # !! now logged in
          redirect_back_or_default('/')    
          flash[:notice] = "Thanks for signing up!"
        end
        wants.xml { render :xml => @user.to_xml }
      end
    else
      respond_to do |wants|
        wants.html do
          flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin."
          render :action => "new"
        end
        wants.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end
end
