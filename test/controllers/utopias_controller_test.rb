require 'test_helper'

class UtopiasControllerTest < ActionController::TestCase
  setup do
    @utopia = utopias(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:utopias)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create utopia" do
    assert_difference('Utopia.count') do
      post :create, utopia: { description: @utopia.description, effect_body: @utopia.effect_body, effect_economy: @utopia.effect_economy, effect_environment: @utopia.effect_environment, effect_fun: @utopia.effect_fun, effect_politics: @utopia.effect_politics, effect_spirituality: @utopia.effect_spirituality, effect_technology: @utopia.effect_technology, email: @utopia.email, realization: @utopia.realization, risks: @utopia.risks, title: @utopia.title }
    end

    assert_redirected_to utopia_path(assigns(:utopia))
  end

  test "should show utopia" do
    get :show, id: @utopia
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @utopia
    assert_response :success
  end

  test "should update utopia" do
    patch :update, id: @utopia, utopia: { description: @utopia.description, effect_body: @utopia.effect_body, effect_economy: @utopia.effect_economy, effect_environment: @utopia.effect_environment, effect_fun: @utopia.effect_fun, effect_politics: @utopia.effect_politics, effect_spirituality: @utopia.effect_spirituality, effect_technology: @utopia.effect_technology, email: @utopia.email, realization: @utopia.realization, risks: @utopia.risks, title: @utopia.title }
    assert_redirected_to utopia_path(assigns(:utopia))
  end

  test "should destroy utopia" do
    assert_difference('Utopia.count', -1) do
      delete :destroy, id: @utopia
    end

    assert_redirected_to utopias_path
  end
end
