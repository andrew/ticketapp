class TicketsController < ApplicationController
  resources_controller_for :tickets
  
  before_filter :check_owner, :except => [:show, :index, :new, :create, :newest]
  before_filter :check_private, :only => [:show]
  before_filter :login_required, :only => [:new, :create, :newest]
  before_filter :newish_ticket?, :only => [:edit]
  
  # TODO needs basic http authentication on .xml calls
  
  def show
    @ticket = Ticket.find(params[:id])
    
    respond_to do |format|
      format.html { @replies = @ticket.replies.not_private.paginate :page => params[:page] }
      format.xml  { render :xml => @ticket }
    end
  end
  
  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.user = current_user
    
    respond_to do |format|
      if @ticket.save
        format.html { flash[:notice] = 'Ticket was successfully created.'
                      redirect_to login_name_path(current_user) }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
        format.js   { render :update do |page|
                        page << "document.title = 'Tickets - Recent Tickets';"
                        page.insert_html :top, "tickets", :partial => 'ticket', :object => @ticket, :locals => {:type => 'multi'}
                        page.visual_effect :highlight, "ticket_#{@ticket.id}" 
                        page.replace_html "new_ticket_msg", "<b>Create a new ticket</b>"
                        page['x_submit'].disabled = false
                      end }
      else
        if @ticket.reply_id != nil
          format.html { flash[:error] = "A Reply requires at least 3 characters for creation"
                        redirect_to ticket_path(@ticket.reply) }
        else
          format.html { flash[:error] = "A Ticket requires at least 3 characters for creation" 
                        redirect_to new_ticket_path }
        end
        format.xml { render :xml => @ticket.errors, :status => :unprocessable_entity }
        format.js { }
      end
    end
  end
  
  def update
    @ticket = Ticket.find(params[:id])
  
    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        flash[:notice] = 'Your Ticket has been updated'
        format.html { redirect_to ticket_path(@ticket) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    respond_to do |format|
      format.html { flash[:notice] = "Ticket deleted"
                    redirect_to login_name_path(@ticket.user) }
      format.xml  { head :ok }
      format.js   { render :update do |page|
                      page.hide "ticket_#{@ticket.id}" 
                    end }
    end
  end
  
  def index
    @tickets = Ticket.recent.not_private.newest_first
    respond_to do |format|
      format.html { @tickets = Ticket.not_private.newest_first.paginate :page => params[:page] }
      format.xml{ render :xml => @tickets }
      format.atom 
      format.rss 
      format.js{ @tickets = Ticket.not_private.newest_first.paginate :page => params[:page]
                  render :update do |page|
                    page << "document.title = 'New Tickets!';" if @tickets.first.created_at > Time.now - 1.minute
                    page.replace_html 'tickets', :partial => "tickets"
                  end }
    end
  end
  
  def newest
    respond_to do |format|
      format.html { @tickets = Ticket.find(:all, :conditions => ['private = ? and created_at > ?', false, current_user.previous_login], :order => 'created_at DESC').paginate :page => params[:page]}
    end
  end

  private
  
  def newish_ticket?
    unless (@ticket.created_at + 5.minutes > Time.now) or (logged_in? and current_user.admin)
      flash[:notice] = "Ticket is too old to edit"
      false
    end
  end
  
  def check_owner 
    access_denied unless logged_in? and (current_user == @ticket.user or current_user.admin)
  end
  
  def check_private
    access_denied if @ticket.private and current_user != @ticket.user
  end
  
end
