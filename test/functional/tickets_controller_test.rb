require File.dirname(__FILE__) + '/../test_helper'
require 'tickets_controller'

# Re-raise errors caught by the controller.
class TicketsController; def rescue_action(e) raise e end; end

class TicketsControllerTest < Test::Unit::TestCase
  fixtures :tickets

  def setup
    @controller = TicketsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:tickets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_ticket
    old_count = Ticket.count
    post :create, :ticket => { }
    assert_equal old_count+1, Ticket.count
    
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  def test_should_show_ticket
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_ticket
    put :update, :id => 1, :ticket => { }
    assert_redirected_to ticket_path(assigns(:ticket))
  end
  
  def test_should_destroy_ticket
    old_count = Ticket.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Ticket.count
    
    assert_redirected_to tickets_path
  end
end
