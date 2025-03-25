require 'test_helper'

class ConfigsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @config = configs(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create config" do
    assert_difference('Config.count') do
      post :create, params: {
                      config: {
                        body: @config.body,
                        description: @config.description,
                        is_public: @config.is_public,
                        name: "new-config"
                      }
                    }
    end

    created_config = Config.find_by(name: "new-config")
    assert_redirected_to config_path(created_config)
  end

  test "should show config" do
    get :show, params: { id: @config.id }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @config.id }
    assert_response :success
  end

  test "should update config" do
    patch :update, params: {
                    id: @config.id,
                    config: {
                      body: @config.body,
                      description: @config.description,
                      is_public: @config.is_public,
                      name: @config.name
                    }
                  }

    updated_config = Config.find(@config.id)
    assert_redirected_to config_path(updated_config)
  end

  test "should destroy config" do
    assert_difference('Config.count', -1) do
      delete :destroy, params: { id: @config.id }
    end

    assert_redirected_to configs_path
  end
end
