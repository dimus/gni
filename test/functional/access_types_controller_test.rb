require File.dirname(__FILE__) + '/../test_helper'

class AccessTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:access_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_access_type
    assert_difference('AccessType.count') do
      post :create, :access_type => { }
    end

    assert_redirected_to access_type_path(assigns(:access_type))
  end

  def test_should_show_access_type
    get :show, :id => access_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => access_types(:one).id
    assert_response :success
  end

  def test_should_update_access_type
    put :update, :id => access_types(:one).id, :access_type => { }
    assert_redirected_to access_type_path(assigns(:access_type))
  end

  def test_should_destroy_access_type
    assert_difference('AccessType.count', -1) do
      delete :destroy, :id => access_types(:one).id
    end

    assert_redirected_to access_types_path
  end
end
