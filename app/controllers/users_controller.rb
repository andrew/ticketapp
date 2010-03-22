class UsersController < ApplicationController
  resources_controller_for :users, :except => :show

  before_filter :check_user, :except => [:index, :show, :new, :create, :activate]

  # TODO needs basic http authentication on .xml calls
  # TODO need to put basic http authentication on replies rss feed

  def index
    respond_to do |format|
      format.html { @users = User.online_last.paginate :page => params[:page] }
      format.atom
      format.rss 
      format.xml do
        @users = User.recent
        render :xml => @users
      end
    end
  end
  
  def show 
    self.resource = find_resource

    respond_to do |format|
      format.html do 
        if logged_in? and @user == current_user
          @ticket = Ticket.new(:private => current_user.privacy_default )
          @tickets = @user.tickets.newest_first.paginate :page => params[:page]
        else  
          @tickets = @user.tickets.newest_first.not_private.paginate :page => params[:page]
        end
      end
      format.atom { @tickets = @user.tickets.recent.not_private.newest_first }
      format.rss { @tickets = @user.tickets.recent.not_private.newest_first }
      format.xml { render :xml => @user }
    end

  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Account was successfully created, an activation email has been sent'
        format.html { redirect_to login_path + "?return_to=#{request.path}"  }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def activate
    self.current_user = User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.activated?
      current_user.last_login = Time.now
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_to user_path(current_user)
  end

  def destroy
    self.resource = find_resource
    @user.destroy
    respond_to do |format|
      flash[:notice] = "Account Removed"
      format.html { redirect_to index_path }
      format.xml  { head :ok }
    end
  end
  
  def replies
    self.resource = find_resource
    respond_to do |format|
      format.html { @replies = @user.replies.paginate(:page => params[:page], :per_page => 10) }
      format.xml  { render :xml => @user.replies }
      format.atom {}
      format.rss {}
    end     
  end
  
  private
  
  def find_resource
    User.find_by_login(params[:id])
  end
  
  def check_user 
    access_denied unless logged_in? and (current_user == @user or current_user.admin)
  end
  
end
