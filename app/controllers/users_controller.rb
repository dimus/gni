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

  def forgotten_password
    @user = User.new
  end

  def update
    @user = User.find_by_email(params[:user][:email])
    respond_to do |format|
      if @user
        @user.password = @user.password_confirmation = _generate_password 
        if @user.update_attributes(params[:user])
          fp = ForgottenPassword.create_send_new_password(@user)
          ForgottenPassword.deliver(fp)
          flash[:notice] = "New password had been sent to your email account"
          format.html { redirect_to root_url}
        end
      else
        flash[:error] = "Email #{params[:user][:email]} is not registered"
        format.html { redirect_to forgotten_password_url }
      end
    end
  end
protected
  def _generate_password(size = 8)
    chars = (('a'..'z').to_a + ('0'..'9').to_a)  + %w(@ # $ % ^ & * ) - %w(I i o 0 1 l 0)
    (1..size).collect{|a| chars[rand(chars.size)] }.join
  end

end
