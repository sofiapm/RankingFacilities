require 'test_helper'

class MeasuresControllerTest < ActionController::TestCase
  setup do
    @measure = measures(:tcc)
    @facility = facilities(:Vodafone)
    @user = users(:joana)
  end

######### Passa se user logged in ############
  test "should get index" do
    sign_in @user
    get :index, facility_id: @facility.id
    assert_response :success
    assert_not_nil assigns(:measures)
  end

  test "should get new" do
    sign_in @user
    get :new, facility_id: @facility.id
    assert_response :success
  end

  test "should create measure" do
    sign_in @user
    assert_difference('Measure.count') do
      post :create, measure: { end_date: @measure.end_date, facility_id: @measure.facility_id, name: @measure.name, start_date: @measure.start_date, user_id: @measure.user_id, value: @measure.value }, facility_id: @facility.id
    end

    assert_redirected_to edit_measure_path(assigns(:measure))
  end

  test "should show measure" do
    sign_in @user
    get :show, id: @measure
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get :edit, id: @measure, facility_id: @facility.id
    assert_response :success
  end

  test "should update measure" do
    sign_in @user
    patch :update, id: @measure, measure: { end_date: @measure.end_date, facility_id: @measure.facility_id, name: @measure.name, start_date: @measure.start_date, user_id: @measure.user_id, value: @measure.value }, facility_id: @facility.id
    assert_redirected_to edit_measure_path(assigns(:measure))
  end

  test "should destroy measure" do
    sign_in @user
    assert_difference('Measure.count', -1) do
      delete :destroy, id: @measure, facility_id: @facility.id
    end

    assert_redirected_to facility_measures_path(facility_id: @facility.id)
  end

  ######### Passa se user NOT logged in ############
  test "should not get index" do
    get :index, facility_id: @facility.id
    assert_response :redirect
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not get new" do
    get :new, facility_id: @facility.id
    assert_response :redirect
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not create measure" do
    assert_difference('FacilityStaticMeasure.count', 0) do
      post :create, measure: { end_date: @measure.end_date, facility_id: @measure.facility_id, name: @measure.name, start_date: @measure.start_date, user_id: @measure.user_id, value: @measure.value }, facility_id: @facility.id
    end
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not show measure" do
    get :show, id: @measure
    assert_response :redirect
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not get edit" do
    get :edit, id: @measure
    assert_response :redirect
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not update measure" do
    patch :update, id: @measure, measure: { end_date: @measure.end_date, facility_id: @measure.facility_id, name: @measure.name, start_date: @measure.start_date, user_id: @measure.user_id, value: @measure.value }, facility_id: @facility.id
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end

  test "should not destroy measure" do
    assert_difference('FacilityStaticMeasure.count', 0) do
      delete :destroy, id: @measure
    end
    assert_redirected_to static_pages_error_you_can_not_access_page_path
  end
end
