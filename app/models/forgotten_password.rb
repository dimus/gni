class ForgottenPassword < ActionMailer::Base

  def send_new_password(user, password)
    recipients user.email
    subject "New password from GNA"
    from "noreply@gnapartnership.org"
    body :recipient => user.login, :password => password
  end
  

end
