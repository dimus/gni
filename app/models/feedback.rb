class Feedback < ActionMailer::Base

  def feedback(feedback_email, feedback_body)
    recipients FEEDBACK_RECIPIENT
    subject "Feedback"
    from feedback_email || NOREPLY_EMAIL
    body :body => feedback_body
  end

end
