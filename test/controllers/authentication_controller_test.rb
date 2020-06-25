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
    pattern = { id: wildcard_matcher, role: @user.role, token: wildcard_matcher }
    assert_json_match(pattern, response.body)
  end
end
