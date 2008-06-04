require File.dirname(__FILE__) + '/../test_helper'

class UriTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:uri_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_uri_type
    assert_difference('UriType.count') do
      post :create, :uri_type => { }
    end

    assert_redirected_to uri_type_path(assigns(:uri_type))
  end

  def test_should_show_uri_type
    get :show, :id => uri_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => uri_types(:one).id
    assert_response :success
  end

  def test_should_update_uri_type
    put :update, :id => uri_types(:one).id, :uri_type => { }
    assert_redirected_to uri_type_path(assigns(:uri_type))
  end

  def test_should_destroy_uri_type
    assert_difference('UriType.count', -1) do
      delete :destroy, :id => uri_types(:one).id
    end

    assert_redirected_to uri_types_path
  end
end
