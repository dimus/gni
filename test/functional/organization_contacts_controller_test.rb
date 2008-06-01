require File.dirname(__FILE__) + '/../test_helper'

class OrganizationContactsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_contacts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_organization_contact
    assert_difference('OrganizationContact.count') do
      post :create, :organization_contact => { }
    end

    assert_redirected_to organization_contact_path(assigns(:organization_contact))
  end

  def test_should_show_organization_contact
    get :show, :id => organization_contacts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => organization_contacts(:one).id
    assert_response :success
  end

  def test_should_update_organization_contact
    put :update, :id => organization_contacts(:one).id, :organization_contact => { }
    assert_redirected_to organization_contact_path(assigns(:organization_contact))
  end

  def test_should_destroy_organization_contact
    assert_difference('OrganizationContact.count', -1) do
      delete :destroy, :id => organization_contacts(:one).id
    end

    assert_redirected_to organization_contacts_path
  end
end
