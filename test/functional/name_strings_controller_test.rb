require File.dirname(__FILE__) + '/../test_helper'

class NameStringsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:name_strings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_name_string
    assert_difference('NameString.count') do
      post :create, :name_string => { }
    end

    assert_redirected_to name_string_path(assigns(:name_string))
  end

  def test_should_show_name_string
    get :show, :id => name_strings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => name_strings(:one).id
    assert_response :success
  end

  def test_should_update_name_string
    put :update, :id => name_strings(:one).id, :name_string => { }
    assert_redirected_to name_string_path(assigns(:name_string))
  end

  def test_should_destroy_name_string
    assert_difference('NameString.count', -1) do
      delete :destroy, :id => name_strings(:one).id
    end

    assert_redirected_to name_strings_path
  end
end
