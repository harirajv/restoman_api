require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
  end

  test "login should return not_found if email is invalid" do
    post login_path, params: { email: 'invalid@email.com', password: 'password' }

    assert_response 404
    assert_json_match(error_response(ERROR_MESSAGES[:invalid_user_email] % 'invalid@email.com'), response.body)
  end

  test "login should return unauthorized if password is invalid" do
    post login_path, params: { email: @user.email, password: 'invalid' }

    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:invalid_password]), response.body)
  end

  test "login should create user token" do
    post login_path, params: { email: @user.email, password: 'password' }
    
    assert_response 200
    pattern = { user_id: @user.id, user_role: @user.role, token: wildcard_matcher }
    assert_json_match(pattern, response.body)
  end

  test "logout should return unauthorized if token is absent" do
    put logout_path
    assert_response 401
    assert_json_match(error_response(ErrorConstants::ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "logout should cause all further requests to return unauthorized" do
    token = generate_jwt(@user)
    put logout_path, headers: { Authorization: token }
    assert_response 204

    get users_url, headers: { 'Authorization': token }
    assert_response 401
    assert_json_match(error_response(ErrorConstants::ERROR_MESSAGES[:logged_out]), response.body)
  end
end
