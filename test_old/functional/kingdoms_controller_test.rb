require File.dirname(__FILE__) + '/../test_helper'

class KingdomsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:kingdoms)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_kingdom
    assert_difference('Kingdom.count') do
      post :create, :kingdom => { }
    end

    assert_redirected_to kingdom_path(assigns(:kingdom))
  end

  def test_should_show_kingdom
    get :show, :id => kingdoms(:eubacteria).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => kingdoms(:eubacteria).id
    assert_response :success
  end

  def test_should_update_kingdom
    put :update, :id => kingdoms(:eubacteria).id, :kingdom => { }
    assert_redirected_to kingdom_path(assigns(:kingdom))
  end

  def test_should_destroy_kingdom
    assert_difference('Kingdom.count', -1) do
      delete :destroy, :id => kingdoms(:eubacteria).id
    end

    assert_redirected_to kingdoms_path
  end
end
