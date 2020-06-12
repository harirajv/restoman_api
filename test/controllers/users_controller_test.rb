require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ErrorConstants
  
  setup do
    @user = users(:admin)
  end

  test "index should return unauthorized when token is absent" do
    get users_url
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "should get index" do
    get users_url, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end

  test "create should return unprocessable_entity when email is not unique" do
    post users_url, params: { name: @user.name, role: @user.role, email: @user.email, password: 'password' }
    assert_response 422
    assert parsed_response[:email].include?(ERROR_MESSAGES[:already_taken])
  end

  test "create should return unprocessable_entity when email format is invalid" do
    post users_url, params: { name: @user.name, role: @user.role, email: 'email', password: 'password' }
    assert_response 422
    assert parsed_response[:email].include?(ERROR_MESSAGES[:is_invalid])
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { name: @user.name, role: @user.role, email: 'new@email.com', password: 'password' }
    end

    assert_response 201
  end

  test "show should return unauthorized when token is absent" do
    get user_url(@user)
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "show should return not_found if user_id is invalid" do
    get user_url(@user), headers: { 'Authorization': generate_jwt(@user) }
  end

  test "should show user" do
    get user_url(@user), headers: { 'Authorization': generate_jwt(@user) }
    assert_response :success
  end

  test "update should return unauthorized when token is absent" do
    put user_url(@user), params: { name: @user.name }
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "update should return forbidden if current user is not admin" do
    not_admin = users(:chef)
    put user_url(@user), params: { name: @user.name }, headers: { 'Authorization': generate_jwt(not_admin) }
    assert_response 403
    assert_equal ERROR_MESSAGES[:unauthorized], parsed_response[:errors]
  end

  test "should update user" do
    put user_url(@user), params: { name: @user.name }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end
end
