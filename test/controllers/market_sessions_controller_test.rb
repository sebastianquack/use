require 'test_helper'

class MarketSessionsControllerTest < ActionController::TestCase
  setup do
    @market_session = market_sessions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:market_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create market_session" do
    assert_difference('MarketSession.count') do
      post :create, market_session: { duration: @market_session.duration, max_survivors: @market_session.max_survivors }
    end

    assert_redirected_to market_session_path(assigns(:market_session))
  end

  test "should show market_session" do
    get :show, id: @market_session
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @market_session
    assert_response :success
  end

  test "should update market_session" do
    patch :update, id: @market_session, market_session: { duration: @market_session.duration, max_survivors: @market_session.max_survivors }
    assert_redirected_to market_session_path(assigns(:market_session))
  end

  test "should destroy market_session" do
    assert_difference('MarketSession.count', -1) do
      delete :destroy, id: @market_session
    end

    assert_redirected_to market_sessions_path
  end
end
