require 'test_helper'

class DishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dish = dishes(:one)
    @user = users(:admin)
  end

  RECORD_NOT_FOUND = ERROR_MESSAGES[:record_not_found] % ['Dish', 'id', -1].freeze

  test "index should return unauthorized when token is absent" do
    get dishes_url
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  # TODO test paginated response
  test "index should return dishes" do
    get dishes_url, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 200
    assert_json_match(Dish.all.map(&:as_json), response.body)
  end

  test "forbidden returned by create if not privileged" do
    @user = users(:waiter)
    post dishes_url, params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)

    @user = users(:chef)
    post dishes_url, params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)
  end

  test "create should return bad_request if required model parameters are not present" do
    post dishes_url, params: { invalid: true }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 400
    assert_equal ERROR_MESSAGES[:missing_params], response.parsed_body['errors'].first
  end

  test "create should return bad_request if unpermitted model parameters are present" do
    post dishes_url, params: { created_at: Time.now }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 400
    assert_equal ERROR_MESSAGES[:invalid_params] % 'created_at', response.parsed_body['errors'].first
  end

  test "should create dish" do
    payload = { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name }
    assert_difference('Dish.count') do
      post dishes_url, params: payload, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    end

    assert_response 201
    pattern = payload.merge({id: wildcard_matcher, is_active: true, created_at: wildcard_matcher, updated_at: wildcard_matcher})
    assert_json_match(pattern, response.body)
  end

  test "not_found returned by show for invalid id" do
    get dish_url(-1), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "should show dish" do
    get dish_url(@dish), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 200
    assert_json_match(Dish.find(@dish.id).as_json, response.body)
  end

  test "forbidden returned by update if restricted action for current_user" do
    @user = users(:waiter)
    put dish_url(@dish), params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name, is_active: false }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)
  end

  test "bad_request returned by update with unpermitted parameters for current_user" do
    @user = users(:chef)
    put dish_url(@dish), params: { cost: @dish.cost, description: @dish.description, image: @dish.image, name: @dish.name, is_active: false }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 400
    unpermitted_fields = %w(name description cost image).join(', ') # Order in error message must be same as Dish.attribute_names
    assert_equal ERROR_MESSAGES[:invalid_params] % unpermitted_fields, response.parsed_body['errors'].first
  end

  test "not_found returned by update for invalid id" do
    @new_dish = dishes(:two)
    put dish_url(-1), params: { cost: @new_dish.cost, description: @new_dish.description, image: @new_dish.image, name: @new_dish.name, is_active: false }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "update should return bad_request if required model parameters are not present" do
    put dish_url(@dish), params: { invalid: true }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 400
    assert_equal ERROR_MESSAGES[:missing_params], response.parsed_body['errors'].first
  end

  test "update should return bad_request if unpermitted model parameters are present" do
    put dish_url(@dish), params: { created_at: Time.now }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 400
    assert_equal ERROR_MESSAGES[:invalid_params] % 'created_at', response.parsed_body['errors'].first
  end

  test "should update dish" do
    @new_dish = dishes(:two)
    payload = { cost: @new_dish.cost, description: @new_dish.description, image: @new_dish.image, name: @new_dish.name, is_active: false }
    put dish_url(@dish), params: payload, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 200
    @dish.reload
    pattern = payload.merge({id: @dish.id, created_at: @dish.created_at.as_json, updated_at: @dish.updated_at.as_json})
    assert_json_match(pattern, response.body)
  end

  test "forbidden returned by destroy if restricted action for current_user" do
    @user = users(:waiter)
    delete dish_url(@dish), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)

    @user = users(:chef)
    delete dish_url(@dish), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)
  end

  test "not_found returned by destroy for invalid id" do
    delete dish_url(-1), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "should destroy dish" do
    assert_difference('Dish.count', -1) do
      delete dish_url(@dish), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    end

    assert_response 204
  end
end
