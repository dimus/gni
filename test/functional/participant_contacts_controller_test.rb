require File.dirname(__FILE__) + '/../test_helper'

class ParticipantContactsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:participant_contacts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_participant_contact
    assert_difference('ParticipantContact.count') do
      post :create, :participant_contact => { }
    end

    assert_redirected_to participant_contact_path(assigns(:participant_contact))
  end

  def test_should_show_participant_contact
    get :show, :id => participant_contacts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => participant_contacts(:one).id
    assert_response :success
  end

  def test_should_update_participant_contact
    put :update, :id => participant_contacts(:one).id, :participant_contact => { }
    assert_redirected_to participant_contact_path(assigns(:participant_contact))
  end

  def test_should_destroy_participant_contact
    assert_difference('ParticipantContact.count', -1) do
      delete :destroy, :id => participant_contacts(:one).id
    end

    assert_redirected_to participant_contacts_path
  end
end
