class SessionsController < ApplicationController
  
  # TODO re-implement openid

  def create
    if @user = User.find_by_login(params[:login])
      self.current_user = User.authenticate(params[:login], params[:password])
      handle_login
    elsif @user = User.find_by_email(params[:login])  
      self.current_user = User.authenticate(@user.login, params[:password])
      handle_login
    else
      flash[:notice] = "Incorrent Login"
      redirect_to :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
  protected

  def handle_login
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      current_user.previous_login = current_user.last_login
      current_user.last_login = Time.now
      current_user.save
      flash[:notice] = "Logged in successfully"
      redirect_back_or_default(return_to_or(tickets_path))
    else
      unless @user.activated?
        flash[:error] = "Your account has not yet been activated"
      else  
        flash[:error] = "Incorrect Password"
      end
      redirect_to(new_session_url)
    end
  end
  
  def return_to_or(default)
    params[:return_to].blank? ? default : params[:return_to].to_s
  end

end
