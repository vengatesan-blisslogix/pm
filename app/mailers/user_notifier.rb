class UserNotifier < ApplicationMailer
  default :from => 'marketing@tvsnext.io'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up with our app' )
  end

  def forget_password_otp_send(user)
  	@user = user
  	mail( :to => @user.email,
    :subject => 'OTP for PMT' )
  end
  def welcome_email(email,name,password)
    @password =password
    @name = name
    @email = email
      mail( :to => email,
      :subject => 'Welcome to PMT' )
  end
end
