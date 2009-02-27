require File.dirname(__FILE__) + '/../test_helper'

class ResponseFormatsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:response_formats)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_response_format
    assert_difference('ResponseFormat.count') do
      post :create, :response_format => { }
    end

    assert_redirected_to response_format_path(assigns(:response_format))
  end

  def test_should_show_response_format
    get :show, :id => response_formats(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => response_formats(:one).id
    assert_response :success
  end

  def test_should_update_response_format
    put :update, :id => response_formats(:one).id, :response_format => { }
    assert_redirected_to response_format_path(assigns(:response_format))
  end

  def test_should_destroy_response_format
    assert_difference('ResponseFormat.count', -1) do
      delete :destroy, :id => response_formats(:one).id
    end

    assert_redirected_to response_formats_path
  end
end
