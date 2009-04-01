class FeedbackController < ApplicationController
  def new
    @user = current_use
  end
  
  def send_feedback
    feedback = Feedback.create_feedback(params[:email],params[:body])
    Feedback.deliver(feedback)
    flash[:notice] = "Your feedback was sent"
    redirect_to root_url
  end
end