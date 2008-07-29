class ForgottenPassword < ActionMailer::Base

  def new_password(user)
    recipients user.email
    subject "New password from GNA"
    from "noreply@gnapartnership.org"
    body :recipient => user.full_name
  end
  

end
