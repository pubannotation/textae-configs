require 'test_helper'

class Api::V1::ConfigsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @config = configs(:two)
  end

  # Test POST api/v1/configs/name
  test "POST_should_create_config" do
    assert_difference("Config.count", 1) do
      post "/api/v1/configs/test-config", params: '{}',
                                          headers: { 'Content-Type': 'application/json' }
    end

    assert_response 201
    assert_equal "Config test-config was successfully created.", JSON.parse(response.body)['message']
  end

  test "POST_should_save_body_without_format" do
    post "/api/v1/configs/test-config", params: '{ "attribute types": "value" }',
                                        headers: { 'Content-Type': 'application/json' }

    assert_equal JSON.generate({ "attribute types": "value" }), Config.last.body
  end

  test "POST_should_save_attributes_with_query_parameter" do
    post "/api/v1/configs/test-config\?description\=abc\&is_public\=true", params: '{}',
                                                                           headers: { 'Content-Type': 'application/json' }

    assert_equal "abc", Config.last.description
    assert_equal true, Config.last.is_public
  end

  # Test GET api/v1/configs/name
  test "GET_should_show_config" do
    get "/api/v1/configs/#{@config.name}"

    assert response.body
    assert_response 200
  end

  test "GET_should_show_formatted_body" do
    get "/api/v1/configs/#{@config.name}"

    expected_response = JSON.pretty_generate(JSON.parse(@config.body))
    assert_equal expected_response, response.body
  end

  # Test PUT/PATCH api/v1/configs/name
  test "PUT_should_update_config" do
    put "/api/v1/configs/#{@config.name}", params: '{ "attribute types": "new_value" }',
                                           headers: { 'Content-Type': 'application/json' }

    assert_response 200
    assert_equal "Config #{@config.name} was successfully updated.", JSON.parse(response.body)['message']
    assert_equal JSON.generate({ "attribute types": "new_value" }), Config.friendly.find(@config.name).body
  end

  test "UPDATE_should_update_attributes_with_query_parameter" do

    put "/api/v1/configs/#{@config.name}\?description\=def\&is_public\=true", headers: { 'Content-Type': 'application/json' }

    assert_equal "def", Config.friendly.find(@config.name).description
    assert_equal true , Config.friendly.find(@config.name).is_public
  end

  # Test DELETE api/v1/configs/name
  test "DELETE_should_delete_config" do
    assert_difference("Config.count", -1) do
      delete "/api/v1/configs/#{@config.name}"
    end

    assert_response 200
    assert_equal "Config #{@config.name} was successfully deleted.", JSON.parse(response.body)['message']
  end

  # Test exceptions
  test "should_return_400_when_request_json_is_invalid_format" do
    post "/api/v1/configs/invalid-config", params: 'invalid json',
                                           headers: { 'Content-Type': 'application/json' }

    assert_response 400
    assert_equal "Invalid JSON format.", JSON.parse(response.body)['error']
  end

  test "should_return_404_when_config_is_not_found" do
    get "/api/v1/configs/non-existent-config"

    assert_response 404
    assert_equal "Could not find the config non-existent-config", JSON.parse(response.body)['error']
  end

  test "should_return_409_when_config_is_already_exists" do
    post "/api/v1/configs/#{@config.name}", params: '{ "attribute types": "value" }',
                                            headers: { 'Content-Type': 'application/json' }

    assert_response 409
    assert_equal "#{@config.name} has already been taken.", JSON.parse(response.body)['error']
  end

  test "should_return_422_when_request_body_is_not_present" do
    post "/api/v1/configs/test-config"

    assert_response 422
    assert_equal "Validation failed: Body can't be blank", JSON.parse(response.body)['error']
  end

  test "should_return_422_when_config_name_is_invalid" do
    post "/api/v1/configs/abc@def", params: '{}',
                                    headers: { 'Content-Type': 'application/json' }

    assert_response 422
  end

  test "should_return_422_when_is_public_is_not_boolean" do
    post "/api/v1/configs/test-config\?is_public\=abc", params: '{}',
                                                        headers: { 'Content-Type': 'application/json' }

    assert_response 422
  end
end
