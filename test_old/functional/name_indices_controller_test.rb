require 'test_helper'

class NameIndicesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:name_indices)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_name_index
    assert_difference('NameIndex.count') do
      post :create, :name_index => { }
    end

    assert_redirected_to name_index_path(assigns(:name_index))
  end

  def test_should_show_name_index
    get :show, :id => name_indices(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => name_indices(:one).id
    assert_response :success
  end

  def test_should_update_name_index
    put :update, :id => name_indices(:one).id, :name_index => { }
    assert_redirected_to name_index_path(assigns(:name_index))
  end

  def test_should_destroy_name_index
    assert_difference('NameIndex.count', -1) do
      delete :destroy, :id => name_indices(:one).id
    end

    assert_redirected_to name_indices_path
  end
end
