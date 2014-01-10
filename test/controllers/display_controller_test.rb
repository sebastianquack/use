require 'test_helper'

class DisplayControllerTest < ActionController::TestCase
  test "should get projection" do
    get :projection
    assert_response :success
  end

  test "should get tv" do
    get :tv
    assert_response :success
  end

end
