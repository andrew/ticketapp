class IndexController < ApplicationController

  # TODO move both forgot_password and reset_password into user controller

  def index
    redirect_to tickets_path if logged_in?
  end

  def forgot_password
    return unless request.post?
    if @user = User.find_by_email(params[:email])
      @user.forgot_password
      @user.save
      redirect_to '/'
      flash[:notice] = "A password reset link has been sent to your email address" 
    else
      flash[:notice] = "Could not find a user with that email address" 
    end
  end
  
  def reset_password
    if !params[:id].blank? and @user = User.find_by_password_reset_code(params[:id])
      @password_reset_code = params[:id]
      return if @user unless params[:password]
      if (params[:password] == params[:password_confirmation])
        self.current_user = @user #for the next two lines to work
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]
        @user.reset_password
        flash[:notice] = current_user.save ? "Password changed and we logged you in" : "Password not changed"
        redirect_back_or_default(login_name_path(current_user))
      else
        flash[:notice] = "Password mismatch, go back and click the email link again" 
        redirect_to '/home'
      end  
    else
      access_denied
    end
  end

end
