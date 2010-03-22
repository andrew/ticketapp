class UserNotifier < ActionMailer::Base
  
  # TODO new format action mailer methods
  
  def new_feedback
    @from        = "ticketapp@gmail.com"
    @subject     = "Tickets - "
    @sent_on     = Time.now
    @recipients  = "andrewnez@gmail.com"
    @subject    += 'Someone left some feedback!'
    @body[:url]  = "http://ticketapp.com/feedbacks"
  end
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://ticketapp.com/activate/#{user.activation_code}"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject    += 'Your password has been reset'
    @body[:url]  = "http://ticketapp.com/"
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += 'Request to change your password'
    @body[:url]  = "http://ticketapp.com/reset_password/#{user.password_reset_code}" 
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://ticketapp.com/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "ticketapp@gmail.com"
      @subject     = "Tickets - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
