require 'test_helper'

class DummyController < ApplicationController
  def index
    head :no_content
  end
end

class DummyControllerTest < ActionDispatch::IntegrationTest
  def setup
    Rails.application.routes.draw { get 'dummy' => 'dummy#index' }
  end

  def teardown
    Rails.application.reload_routes!
  end

  test 'dummy routing' do
    assert_routing 'dummy', { controller: 'dummy', action: 'index' }
  end

  test 'should return not_found for invalid subdomain' do
    host! 'invalid.restoman.com'
    get dummy_path, as: :json
    assert_response :not_found
    assert_json_match(error_response(ERROR_MESSAGES[:record_not_found] % [Account, 'subdomain', 'invalid']), response.body)
  end

  test 'should return unauthorized if subdomain and account_id in redis do not match' do
    cafe_user = users(:cafe_admin)
    token = JsonWebToken.generate_token(cafe_user)
    get dummy_path, headers: { 'Authorization': JsonWebToken.generate_token(cafe_user) }, as: :json
    assert_response :unauthorized
    assert_json_match(error_response(ERROR_MESSAGES[:token_invalid]), response.body)
  end

  test 'valid request' do
    get dummy_path, headers: { 'Authorization': JsonWebToken.generate_token(users(:admin)) }, as: :json
    assert_response :no_content
  end
end
