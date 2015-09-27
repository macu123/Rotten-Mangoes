class UserMailer < ActionMailer::Base
  default from: "chenj59@mcmaster.ca"

  def delete_messege(user)
    @user = user
    mail(to: @user.email, subject: 'Your account was deleted by administrator')
  end
end