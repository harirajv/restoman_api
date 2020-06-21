class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Restoman')
  end

  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: "Password reset for #{@user.name}")
  end
end
