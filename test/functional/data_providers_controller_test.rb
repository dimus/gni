require File.dirname(__FILE__) + '/../test_helper'

class DataProvidersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:data_providers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_data_provider
    assert_difference('DataProvider.count') do
      post :create, :data_provider => { }
    end

    assert_redirected_to data_provider_path(assigns(:data_provider))
  end

  def test_should_show_data_provider
    get :show, :id => data_providers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => data_providers(:one).id
    assert_response :success
  end

  def test_should_update_data_provider
    put :update, :id => data_providers(:one).id, :data_provider => { }
    assert_redirected_to data_provider_path(assigns(:data_provider))
  end

  def test_should_destroy_data_provider
    assert_difference('DataProvider.count', -1) do
      delete :destroy, :id => data_providers(:one).id
    end

    assert_redirected_to data_providers_path
  end
end
