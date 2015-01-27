require 'test_helper'

class FacilitiesControllerTest < ActionController::TestCase
  setup do
    @static_measure = facility_static_measures(:nfa)
    @address = addresses(:jane_address)
    @role = roles(:jane_occupant_role)
    @facility = facilities(:Vodafone)
    @user = users(:jane)
    :initialize_facility_static_measures
  end

  test "should get index if loged in" do
    sign_in @user
    get :index, role_id: @facility.role_id
    assert_response :success
    assert_not_nil assigns(:facilities)
  end

  test "index-should redirect to error page if not loged in" do
    get :index, role_id: @facility.role_id
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should get new if loged in" do
    sign_in @user
    get :new, role_id: @facility.role_id
    assert_response :success
  end

  test "new-should get redirect to error page if not loged in" do
    get :new, role_id: @facility.role_id
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  # test "should create facility if loged in" do
  #   sign_in @user

  #   assert_difference('Facility.count') do
  #     post :create, facility: { name: @facility.name, role_id: @role.id, address_id: @address.id, user_id: @user.id,
  #                               street: @address.street, city: @address.city, country: @address.country, zip_code: @address.zip_code}
  #   end

  #   assert_redirected_to edit_facility_path(assigns(:facility))
  # end

  test "create-should get redirect to error page if not loged in" do
    assert_difference('Facility.count', 0) do
      post :create, facility: { name: @facility.name}, role_id: @facility.role_id
    end
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should show facility if loged in" do
    sign_in @user
    get :show, id: @facility
    assert_response :success
  end

  test "show-should get redirect to error page if not loged in" do
    get :show, id: @facility
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should get edit if loged in" do
    sign_in @user
    get :edit, id: @facility
    assert_response :success
  end

  test "edit-should get redirect to error page if not loged in" do
    get :edit, id: @facility
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should update facility if loged in" do
    sign_in @user
    patch :update, id: @facility, facility: { name: @facility.name}
    assert_redirected_to edit_facility_path(@facility.id)
  end

  test "update-should get redirect to error page if not loged in" do
    patch :update, id: @facility, facility: { name: @facility.name}
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should destroy facility if loged in" do
    sign_in @user
    @static_measure.facility_id = @facility.id
    assert_difference('Facility.count', -1) do
      delete :destroy, id: @facility, facility: { name: @facility.name}
    end

    assert_redirected_to success_page_url
  end


  test "destroy-should get redirect to error page if not loged in" do
    assert_difference('Facility.count', 0) do
      delete :destroy, id: @facility
    end
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end
end
