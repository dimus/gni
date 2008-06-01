require File.dirname(__FILE__) + '/../test_helper'

class DataProviderRolesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:data_provider_roles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_data_provider_role
    assert_difference('DataProviderRole.count') do
      post :create, :data_provider_role => { }
    end

    assert_redirected_to data_provider_role_path(assigns(:data_provider_role))
  end

  def test_should_show_data_provider_role
    get :show, :id => data_provider_roles(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => data_provider_roles(:one).id
    assert_response :success
  end

  def test_should_update_data_provider_role
    put :update, :id => data_provider_roles(:one).id, :data_provider_role => { }
    assert_redirected_to data_provider_role_path(assigns(:data_provider_role))
  end

  def test_should_destroy_data_provider_role
    assert_difference('DataProviderRole.count', -1) do
      delete :destroy, :id => data_provider_roles(:one).id
    end

    assert_redirected_to data_provider_roles_path
  end
end
