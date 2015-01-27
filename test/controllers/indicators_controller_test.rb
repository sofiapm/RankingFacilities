require 'test_helper'

class IndicatorsControllerTest < ActionController::TestCase
  setup do
    @role = roles(:jane_occupant_role)
    @user = users(:jane)
  end
  test "should get index" do
  	sign_in @user
    get :index
    assert_response :success
  end

end
