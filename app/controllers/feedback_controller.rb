class FeedbackController < ApplicationController
  def new
    @user = current_user
  end
  
  def send_feedback
    feedback_email = params[:email].strip.blank? ? 'Unknown' : params[:email].strip
    fb = FeedbackMailer.create_feedback(feedback_email,params[:body])
    FeedbackMailer.deliver(fb)
    flash[:notice] = "Your feedback was sent"
    redirect_to root_url
  end
end