require File.dirname(__FILE__) + '/../test_helper'

class DataSourcesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:data_sources)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_data_source
    assert_difference('DataSource.count') do
      post :create, :data_source => { }
    end

    assert_redirected_to data_source_path(assigns(:data_source))
  end

  def test_should_show_data_source
    get :show, :id => data_sources(:bees_nhm).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => data_sources(:bees_nhm).id
    assert_response :success
  end

  def test_should_update_data_source
    put :update, :id => data_sources(:bees_nhm).id, :data_source => { }
    assert_redirected_to data_source_path(assigns(:data_source))
  end

  def test_should_destroy_data_source
    assert_difference('DataSource.count', -1) do
      delete :destroy, :id => data_sources(:bees_nhm).id
    end

    assert_redirected_to data_sources_path
  end
end
