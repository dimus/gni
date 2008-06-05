require File.dirname(__FILE__) + '/../test_helper'

class OrganizationMembershipsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_memberships)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_organization_membership
    assert_difference('OrganizationMembership.count') do
      post :create, :organization_membership => { }
    end

    assert_redirected_to organization_membership_path(assigns(:organization_membership))
  end

  def test_should_show_organization_membership
    get :show, :id => organization_memberships(:nhm_john).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => organization_memberships(:nhm_john).id
    assert_response :success
  end

  def test_should_update_organization_membership
    put :update, :id => organization_memberships(:nhm_john).id, :organization_membership => { }
    assert_redirected_to organization_membership_path(assigns(:organization_membership))
  end

  def test_should_destroy_organization_membership
    assert_difference('OrganizationMembership.count', -1) do
      delete :destroy, :id => organization_memberships(:nhm_john).id
    end

    assert_redirected_to organization_memberships_path
  end
end
