require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  setup do
    @role = roles(:occupant_role)
    @user = users(:joana)
  end
  ######## Passa se Loged In #########
  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  test "should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should create role" do
    sign_in @user
    assert_difference('Role.count') do
      post :create, role: { name: "Facility Manager" }
    end

    assert_redirected_to role_path(assigns(:role))
  end

  test "should show role" do
    sign_in @user
    get :show, id: @role
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get :edit, id: @role
    assert_response :success
  end

  test "should update role" do
    sign_in @user
    patch :update, id: @role, role: { name: @role.name }
    assert_redirected_to edit_role_path(assigns(:role))
  end

  test "should destroy role" do
    sign_in @user
    assert_difference('Role.count', -1) do
      delete :destroy, id: @role
    end

    assert_redirected_to roles_path
  end

  ######## Passa se NOT Loged In #########

  test "should not get index" do
    get :index
    assert_response :redirect
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not get new" do
    get :new
    assert_response :redirect
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not create role" do
    assert_difference('Role.count', 0) do
      post :create, role: { name: @role.name }
    end

    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not show role" do
    get :show, id: @role
    assert_response :redirect
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not get edit" do
    get :edit, id: @role
    assert_response :redirect
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not update role" do
    patch :update, id: @role, role: { name: @role.name }
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not destroy role" do
    assert_difference('Role.count', 0) do
      delete :destroy, id: @role
    end

    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end
end
