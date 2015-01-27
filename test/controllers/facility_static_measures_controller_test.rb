require 'test_helper'

class FacilityStaticMeasuresControllerTest < ActionController::TestCase
  setup do
    @facility_static_measure = facility_static_measures(:nfa)
    @facility = facilities(:Vodafone)
    @user = users(:jane)
  end

######### Passa se user logged in ############
  test "should get index" do
    sign_in @user
    get :index, facility_id: @facility.id
    assert_response :success
    assert_not_nil assigns(:facility_static_measures)
  end

  test "should get new" do
    sign_in @user
    get :new, facility_id: @facility.id
    assert_response :success
  end

  test "should create facility_static_measure" do
    sign_in @user
    assert_difference('FacilityStaticMeasure.count') do
      post :create, facility_static_measure: { end_date: @facility_static_measure.end_date, facility_id: @facility_static_measure.facility_id, name: @facility_static_measure.name, start_date: @facility_static_measure.start_date, user_id: @facility_static_measure.user_id, value: @facility_static_measure.value }, facility_id: @facility.id
    end

    assert_redirected_to edit_facility_static_measure_path(assigns(:facility_static_measure))
  end

  test "should show facility_static_measure" do
    sign_in @user
    get :show, id: @facility_static_measure
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get :edit, id: @facility_static_measure, facility_id: @facility.id
    assert_response :success
  end

  test "should update facility_static_measure" do
    sign_in @user
    patch :update, id: @facility_static_measure, facility_static_measure: { end_date: @facility_static_measure.end_date, facility_id: @facility_static_measure.facility_id, name: @facility_static_measure.name, start_date: @facility_static_measure.start_date, user_id: @facility_static_measure.user_id, value: @facility_static_measure.value }, facility_id: @facility.id
    assert_redirected_to edit_facility_static_measure_path(assigns(:facility_static_measure))
  end

  test "should destroy facility_static_measure" do
    sign_in @user
    assert_difference('FacilityStaticMeasure.count', -1) do
      delete :destroy, id: @facility_static_measure, facility_id: @facility.id
    end

    assert_redirected_to facility_facility_static_measures_path(facility_id: @facility.id)
  end

  ######### Passa se user NOT logged in ############
  test "should not get index" do
    get :index, facility_id: @facility.id
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should not get new" do
    get :new, facility_id: @facility.id
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should not create facility_static_measure" do
    assert_difference('FacilityStaticMeasure.count', 0) do
      post :create, facility_static_measure: { end_date: @facility_static_measure.end_date, facility_id: @facility_static_measure.facility_id, name: @facility_static_measure.name, start_date: @facility_static_measure.start_date, user_id: @facility_static_measure.user_id, value: @facility_static_measure.value }, facility_id: @facility.id
    end
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should not show facility_static_measure" do
    get :show, id: @facility_static_measure
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should not get edit" do
    get :edit, id: @facility_static_measure
    assert_response :redirect
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should not update facility_static_measure" do
    patch :update, id: @facility_static_measure, facility_static_measure: { end_date: @facility_static_measure.end_date, facility_id: @facility_static_measure.facility_id, name: @facility_static_measure.name, start_date: @facility_static_measure.start_date, user_id: @facility_static_measure.user_id, value: @facility_static_measure.value }, facility_id: @facility.id
    assert_redirected_to error_you_can_not_access_page_path
  end

  test "should not destroy facility_static_measure" do
    assert_difference('FacilityStaticMeasure.count', 0) do
      delete :destroy, id: @facility_static_measure
    end
    assert_redirected_to error_you_can_not_access_page_path
  end
end
