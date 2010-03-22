require File.dirname(__FILE__) + '/../test_helper'
require 'csses_controller'

# Re-raise errors caught by the controller.
class CssesController; def rescue_action(e) raise e end; end

class CssesControllerTest < Test::Unit::TestCase
  fixtures :csses

  def setup
    @controller = CssesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:csses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_css
    old_count = Css.count
    post :create, :css => { }
    assert_equal old_count+1, Css.count
    
    assert_redirected_to css_path(assigns(:css))
  end

  def test_should_show_css
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_css
    put :update, :id => 1, :css => { }
    assert_redirected_to css_path(assigns(:css))
  end
  
  def test_should_destroy_css
    old_count = Css.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Css.count
    
    assert_redirected_to csses_path
  end
end
