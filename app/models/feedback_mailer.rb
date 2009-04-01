class FeedbackMailer < ActionMailer::Base

  def feedback(feedback_email, feedback_body)
    recipients FEEDBACK_EMAIL
    subject "GNI Feedback"
    from NOREPLY_EMAIL
    body :body => feedback_body, :feedback_email => feedback_email
  end

end
