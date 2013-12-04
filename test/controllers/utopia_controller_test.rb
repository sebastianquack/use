require 'test_helper'

class UtopiaControllerTest < ActionController::TestCase
  setup do
    @utopium = utopia(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:utopia)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create utopium" do
    assert_difference('Utopium.count') do
      post :create, utopium: { description: @utopium.description, effect_body: @utopium.effect_body, effect_economy: @utopium.effect_economy, effect_environment: @utopium.effect_environment, effect_fun: @utopium.effect_fun, effect_politics: @utopium.effect_politics, effect_spirituality: @utopium.effect_spirituality, effect_technology: @utopium.effect_technology, email: @utopium.email, realization: @utopium.realization, risks: @utopium.risks, title: @utopium.title }
    end

    assert_redirected_to utopium_path(assigns(:utopium))
  end

  test "should show utopium" do
    get :show, id: @utopium
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @utopium
    assert_response :success
  end

  test "should update utopium" do
    patch :update, id: @utopium, utopium: { description: @utopium.description, effect_body: @utopium.effect_body, effect_economy: @utopium.effect_economy, effect_environment: @utopium.effect_environment, effect_fun: @utopium.effect_fun, effect_politics: @utopium.effect_politics, effect_spirituality: @utopium.effect_spirituality, effect_technology: @utopium.effect_technology, email: @utopium.email, realization: @utopium.realization, risks: @utopium.risks, title: @utopium.title }
    assert_redirected_to utopium_path(assigns(:utopium))
  end

  test "should destroy utopium" do
    assert_difference('Utopium.count', -1) do
      delete :destroy, id: @utopium
    end

    assert_redirected_to utopia_path
  end
end
