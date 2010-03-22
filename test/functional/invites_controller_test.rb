require File.dirname(__FILE__) + '/../test_helper'
require 'invites_controller'

# Re-raise errors caught by the controller.
class InvitesController; def rescue_action(e) raise e end; end

class InvitesControllerTest < Test::Unit::TestCase
  fixtures :invites

  def setup
    @controller = InvitesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:invites)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_invite
    old_count = Invite.count
    post :create, :invite => { }
    assert_equal old_count+1, Invite.count
    
    assert_redirected_to invite_path(assigns(:invite))
  end

  def test_should_show_invite
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_invite
    put :update, :id => 1, :invite => { }
    assert_redirected_to invite_path(assigns(:invite))
  end
  
  def test_should_destroy_invite
    old_count = Invite.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Invite.count
    
    assert_redirected_to invites_path
  end
end
