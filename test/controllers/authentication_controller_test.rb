require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users(:admin)
  end

  test "login should return not_found if email is invalid" do
    post login_path, params: { email: 'invalid@email.com', password: 'password' }, as: :json

    assert_response 404
    assert_json_match(error_response(ERROR_MESSAGES[:invalid_user_email] % 'invalid@email.com'), response.body)
  end

  test "login should return unauthorized if password is invalid" do
    post login_path, params: { email: @user.email, password: 'invalid' }, as: :json

    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:invalid_password]), response.body)
  end

  test "login should create user token" do
    post login_path, params: { email: @user.email, password: 'password' }, as: :json
    
    assert_response 200
    pattern = { user: @user.facade, token: wildcard_matcher }
    assert_json_match(pattern, response.body)
  end

  test "forgot should return not_found if email is invalid" do
    post forgot_path, params: { email: 'invalid@email.com' }, as: :json
    
    assert_response 404
    assert_json_match(error_response(ERROR_MESSAGES[:invalid_user_email] % 'invalid@email.com'), response.body)
  end

  test "forgot should reset password token and send password reset email" do
    assert_enqueued_with(job: UserMailer.delivery_job, args: [ 'UserMailer', 'reset_password_email', 'deliver_now', @user], queue: 'mailers') do
      post forgot_path, params: { email: @user.email }, as: :json
    end

    assert_response 200
    assert_not_equal @user.reset_password_token, @user.reload.reset_password_token
    assert_equal Time.now.utc.iso8601, @user.reset_password_sent_at.iso8601
  end

  test "reset should return bad_request if token is not present in params" do
    post reset_path, params: { email: @user.email }, as: :json

    assert_response 400
    assert_json_match(error_response(ERROR_MESSAGES[:token_expired]), response.body)
  end

  test "reset should return bad_request if token is expired" do
    @user.update(reset_password_sent_at: Time.utc(1980))
    post reset_path, params: { email: @user.email }, as: :json
    
    assert_response 400
    assert_json_match(error_response(ERROR_MESSAGES[:token_expired]), response.body)
  end

  test "reset should update password" do
    # First send forgot password request to generate reset token
    post forgot_path, params: { email: @user.email }, as: :json

    # Reset password with new value
    new_password = "MyNewPassword123"
    @user.reload
    post reset_path, params: { email: @user.email, password: new_password, password_confirmation: new_password, token: @user.reset_password_token }, as: :json
    
    assert_response 200

    # Login with new password should work
    post login_path, params: { email: @user.email, password: new_password }, as: :json
    
    assert_response 200
  end

  test "logout should return reset_content if token is absent or expired or has invalid format" do
    delete logout_path, as: :json
    assert_response 205

    expired_token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE2NDA3MTA4MDEsImV4cCI6MTY0MDcxMjYwMX0.uR5mX8LOVhhVioowj2RuP6yjw4ObgzEXLsC0eom6fHU"
    delete logout_path, headers: { Authorization: expired_token }, as: :json
    assert_response 205
  end

  test "logout should cause all further requests to return unauthorized" do
    token = generate_jwt(@user)
    delete logout_path, headers: { Authorization: token }, as: :json
    assert_response 204

    get users_url, headers: { 'Authorization': token }, as: :json
    assert_response 401
    assert_json_match(error_response(ErrorConstants::ERROR_MESSAGES[:logged_out]), response.body)
  end
end
