class ForgottenPassword < ActionMailer::Base

  def send_new_password(user)
    recipients user.email
    subject "New password from GNA"
    from NOREPLY_EMAIL
    body :recipient => user.login, :password => user.password
  end
  

end
