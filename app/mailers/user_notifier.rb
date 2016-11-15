class UserNotifier < ApplicationMailer
  default :from => 'pmo@tvsnext.io'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
     mail( :to => @user.email,
    :subject => 'Thanks for signing up with Linchpin' )
  end

  def forget_password_otp_send(user)
  	@user = user
  	  mail( :to => @user.email,
      :subject => 'OTP for Linchpin' )
  end
  
  def welcome_email(email,name,password)
    @password =password
    @name = name
    @email = email
      mail( :to => email,
      :subject => 'Welcome to Linchpin' )
  end
  def welcome_manager(email,name)
    @name = name
    @email = email
    puts "--------man-----#{@email}-------------"
      mail( :to => "vengat.r@tvsnext.io",
      :subject => 'Welcome Manager' )
  end
  def welcome_user(email,name)
    @name = name
    @email = email
    puts "--------usr-----#{@email}-------------"
    @manager_mail = "manager"
      mail( :to => "yogesh.s1@tvsnext.io",
      :subject => 'Welcome User' )
  end
end
