class FeedbacksController < ApplicationController
  resources_controller_for :feedbacks
  
  before_filter :check_admin, :except => [:new, :create]

  def create
    @feedback = Feedback.new(params[:feedback])
    
    if logged_in? # TODO move these into view/form
      @feedback.name = current_user.login
      @feedback.email = current_user.email
    end
    
    respond_to do |format|
      if (logged_in? || verify_recaptcha(@feedback)) && @feedback.save
        flash[:notice] = "Thanks for the feedback, we'll get right on it!"
        format.html { redirect_to index_url() }
        format.xml  { head :created, :location => index_url() }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invite.errors.to_xml }
      end
    end
  end
  
  private
  
  def find_resources
    Feedback.paginate :page => params[:page], :order => "created_at DESC"
  end
 
end
