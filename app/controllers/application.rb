class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable
  
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  
  helper :application
  before_filter :login_from_cookie
  
  filter_parameter_logging :password, :password_confirmation
  
  protect_from_forgery

  def check_admin 
    access_denied unless logged_in? and current_user.admin?
  end
    
  helper_method :iphone_user_agent?
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end
  
  helper_method :parent_resources_path
  def parent_resources_path(resources)
    "/" + resources.map{|r| r.class.to_s.underscore.pluralize + '/' + r.to_param}.join('/')
  end

end
