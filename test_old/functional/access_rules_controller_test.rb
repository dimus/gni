require File.dirname(__FILE__) + '/../test_helper'

class AccessRulesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:access_rules)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_access_rule
    assert_difference('AccessRule.count') do
      post :create, :access_rule => { }
    end

    assert_redirected_to access_rule_path(assigns(:access_rule))
  end

  def test_should_show_access_rule
    get :show, :id => access_rules(:bees_nhm_can_resolve_url).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => access_rules(:bees_nhm_can_resolve_url).id
    assert_response :success
  end

  def test_should_update_access_rule
    put :update, :id => access_rules(:bees_nhm_can_resolve_url).id, :access_rule => { }
    assert_redirected_to access_rule_path(assigns(:access_rule))
  end

  def test_should_destroy_access_rule
    assert_difference('AccessRule.count', -1) do
      delete :destroy, :id => access_rules(:bees_nhm_can_resolve_url).id
    end

    assert_redirected_to access_rules_path
  end
end
