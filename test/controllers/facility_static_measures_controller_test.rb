require 'test_helper'

class FacilityStaticMeasuresControllerTest < ActionController::TestCase
  setup do
    @facility_static_measure = facility_static_measures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:facility_static_measures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create facility_static_measure" do
    assert_difference('FacilityStaticMeasure.count') do
      post :create, facility_static_measure: { end_date: @facility_static_measure.end_date, facility_id: @facility_static_measure.facility_id, name: @facility_static_measure.name, start_date: @facility_static_measure.start_date, user_id: @facility_static_measure.user_id, value: @facility_static_measure.value }
    end

    assert_redirected_to facility_static_measure_path(assigns(:facility_static_measure))
  end

  test "should show facility_static_measure" do
    get :show, id: @facility_static_measure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @facility_static_measure
    assert_response :success
  end

  test "should update facility_static_measure" do
    patch :update, id: @facility_static_measure, facility_static_measure: { end_date: @facility_static_measure.end_date, facility_id: @facility_static_measure.facility_id, name: @facility_static_measure.name, start_date: @facility_static_measure.start_date, user_id: @facility_static_measure.user_id, value: @facility_static_measure.value }
    assert_redirected_to facility_facility_static_measure_path(assigns(:facility_static_measure))
  end

  test "should destroy facility_static_measure" do
    assert_difference('FacilityStaticMeasure.count', -1) do
      delete :destroy, id: @facility_static_measure
    end

    assert_redirected_to facility_facility_static_measures_path
  end
end
