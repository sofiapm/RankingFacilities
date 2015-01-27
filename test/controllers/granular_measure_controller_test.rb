require 'test_helper'

class GranularMeasureControllerTest < ActionController::TestCase
  setup do
    @role = roles(:jane_occupant_role)
    @user = users(:jane)
  end
  test "should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should get create" do
    sign_in @user
    get :create
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get :edit
    assert_response :success
  end

  test "should get update" do
    sign_in @user
    get :update
    assert_response :success
  end

  test "should get destroy" do
    sign_in @user
    get :destroy
    assert_response :success
  end

end
