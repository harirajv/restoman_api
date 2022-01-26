require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper
  include ErrorConstants

  RECORD_NOT_FOUND = ERROR_MESSAGES[:record_not_found] % ['User', 'id', 0].freeze
  
  setup do
    @user = users(:admin)
  end

  test "index should return unauthorized when token is absent" do
    get users_url, as: :json
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "should get index" do
    get users_url, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 200
    assert_equal User.all.map(&:facade).as_json, response.parsed_body
  end

  test "create should return unauthorized when token is absent" do
    post users_url, params: { name: @user.name, role: @user.role, email: 'new@email.com', password: 'password' }, as: :json
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "create should return forbidden if user does not have privilege" do
    not_admin = users(:waiter)
    post users_url, params: { name: @user.name, role: @user.role, email: 'new@email.com', password: 'password' }, headers: { 'Authorization': generate_jwt(not_admin) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)

    not_admin = users(:chef)
    post users_url, params: { name: @user.name, role: @user.role, email: 'new@email.com', password: 'password' }, headers: { 'Authorization': generate_jwt(not_admin) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)
  end

  test "create should return bad_request if required model parameters are not present" do
    post users_url, params: { invalid: true }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 400
    assert_equal ERROR_MESSAGES[:missing_params], response.parsed_body['errors'].first
  end

  test "should create user" do
    payload = { name: @user.name, role: @user.role, email: 'new@email.com', password: 'password', password_confirmation: 'password' }
    assert_emails 1 do
      assert_difference('User.count') do
        post users_url, params: payload, headers: { 'Authorization': generate_jwt(@user) }, as: :json
      end
    end

    assert_response 201

    pattern = payload.merge({ id: wildcard_matcher, created_at: wildcard_matcher, updated_at: wildcard_matcher })
    pattern.except!(:password, :password_confirmation)
    assert_json_match(pattern, response.body)
  end

  test "show should return unauthorized when token is absent" do
    get user_url(@user), as: :json
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "show should return not_found if user_id is invalid" do
    get user_url(0), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "should show user" do
    get user_url(@user), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 200
    assert_equal @user.facade.as_json, response.parsed_body
  end

  test "update should return unauthorized when token is absent" do
    put user_url(@user), params: { name: @user.name }, as: :json
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "update should return forbidden if current user is not admin" do
    not_admin = users(:waiter)
    put user_url(not_admin), params: { role: not_admin.role }, headers: { 'Authorization': generate_jwt(not_admin) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)

    not_admin = users(:chef)
    put user_url(not_admin), params: { role: not_admin.role }, headers: { 'Authorization': generate_jwt(not_admin) }, as: :json
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)
  end

  test "update should return bad_request if parameters are empty" do
    put user_url(@user), params: { invalid: true }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 400
    assert_json_match(error_response(ERROR_MESSAGES[:missing_params]), response.body)
  end

  test "update should return bad_request if required model parameters are not present" do
    put user_url(@user), params: { something: true }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 400
    assert_json_match(error_response(ERROR_MESSAGES[:missing_params]), response.body)
  end

  # test update if unpermitted model parameters they must be filtered out

  test "update should return not_found if user_id is invalid" do
    put user_url(0), params: { name: @user.name }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "should update user" do
    payload = { name: 'new_name' }
    put user_url(@user), params: payload, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 200
    @user.reload
    pattern = payload.merge(id: @user.id, role: @user.role, created_at: @user.created_at.as_json, updated_at: @user.updated_at.as_json, email: @user.email)
    assert_json_match(pattern, response.body)
  end
end
