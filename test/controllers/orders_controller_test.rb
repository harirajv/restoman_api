require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest

  RECORD_NOT_FOUND = ERROR_MESSAGES[:record_not_found] % ['Order', 'id', 0].freeze

  setup do
    @order = orders(:one)
    @user = users(:waiter)
  end

  test "index should return unauthorized when token is absent" do
    get orders_url, as: :json

    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "index should return orders with order items" do
    get orders_url, headers: { 'Authorization': generate_jwt(@user) }, as: :json

    assert_response 200
    assert_equal Order.includes(:order_items).to_json(include: :order_items), response.body
  end

  test "create should return unauthorized when token is absent" do
    post orders_url, params: { is_active: @order.is_active, table_no: @order.table_no }, as: :json

    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "create should return forbidden if current user is chef" do
    chef = users(:chef)
    post orders_url, params: { table_no: @order.table_no }, headers: { 'Authorization': generate_jwt(chef) }, as: :json

    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)
  end

  # Fix rescue block and handle with ActionController::ParameterMissing rescue block
  # test "create should return bad_request if required order parameters are not present" do
  #   post orders_url, params: { invalid: true }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
  #   assert_response 422
  #   assert_equal ERROR_MESSAGES[:missing_params], response.parsed_body['errors'].first
  # end

  # Fix rescue block and handle with  ActionController::UnpermittedParameters rescue block
  # test "create should return bad_request if unpermitted order parameters are present" do
  #   post orders_url, params: { created_at: Time.now }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
  #   assert_response 422
  #   assert_equal ERROR_MESSAGES[:invalid_params] % 'created_at', response.parsed_body['errors'].first
  # end

  test "should create order with order_items" do
    order_items = [{dish_id: dishes(:one).id, quantity: 3}, {dish_id: dishes(:two).id, quantity: 5}]
    payload = { table_no: @order.table_no, order_items: order_items }

    assert_difference ->{ Order.count } => 1, -> { OrderItem.count } => 2 do
      post orders_url, params: payload, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    end

    assert_response 201
    pattern = payload.merge({id: wildcard_matcher, is_active: true, user_id: @user.id, created_at: wildcard_matcher, updated_at: wildcard_matcher})
    pattern[:order_items].each { |order_item| order_item.merge!({id: wildcard_matcher, order_id: response.parsed_body['id'], status: 'preparing', created_at: wildcard_matcher, updated_at: wildcard_matcher}) }
    assert_json_match(pattern, response.body)
  end

  test "show should return unauthorized when token is absent" do
    get order_url(@order), as: :json
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "show should return not_found if order_id is invalid" do
    get order_url(0), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "should show order" do
    get order_url(@order), headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 200
    assert_json_match(Order.find(@order.id).as_json(include: :order_items), response.body)
  end

  test "update should return unauthorized when token is absent" do
    put order_url(@order), params: { is_active: @order.is_active, table_no: @order.table_no }, as: :json
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "update should return forbidden if current_user is chef and status parameter is other than completed" do
    chef = users(:chef)
    put order_url(@order), params: { order_items: [{ id: @order.order_items.first.id, status: :preparing }] }, headers: { Authorization: generate_jwt(chef) }, as: :json
    assert_response 403
    error_msg = ERROR_MESSAGES[:update_not_allowed] % "status preparing in item ##{@order.order_items.first.id}"
    assert_json_match(error_response(error_msg), response.body)

    put order_url(@order), params: { order_items: [{ id: @order.order_items.first.id, status: :cancelled }] }, headers: { Authorization: generate_jwt(chef) }, as: :json
    assert_response 403
    error_msg = ERROR_MESSAGES[:update_not_allowed] % "status cancelled in item ##{@order.order_items.first.id}"
    assert_json_match(error_response(error_msg), response.body)
  end

  test "update should return forbidden if current_user is waiter and status parameter is completed" do
    waiter = users(:waiter)
    put order_url(@order), params: { order_items: [{ id: @order.order_items.first.id, status: :completed }] }, headers: { Authorization: generate_jwt(waiter) }, as: :json
    assert_response 403
    error_msg = ERROR_MESSAGES[:update_not_allowed] % "status completed in item ##{@order.order_items.first.id}"
    assert_json_match(error_response(error_msg), response.body)
  end

  test "update should return not_found if order_id is invalid" do
    put order_url(0), params: { is_active: @order.is_active, table_no: @order.table_no }, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "update should update order and order_items" do
    order_items = [{id: order_items(:one).id, dish_id: dishes(:one).id, quantity: 10}, { dish_id: dishes(:two).id, quantity: 20 }]
    payload = { table_no: 100, order_items: order_items }

    assert_difference('OrderItem.count') do
      put order_url(@order), params: payload, headers: { 'Authorization': generate_jwt(@user) }, as: :json
    end
    
    assert_response 200
    
    pattern = payload.merge({ id: @order.id, is_active: true, user_id: @user.id, created_at: @order.created_at, updated_at: wildcard_matcher })
    pattern[:order_items][0].merge! ({ order_id: @order.id, status: order_items(:one).status, created_at: order_items(:one).created_at, updated_at: wildcard_matcher })
    pattern[:order_items][1].merge! ({ id: wildcard_matcher, order_id: @order.id,  status: OrderItem.statuses.first[0], created_at: wildcard_matcher, updated_at: wildcard_matcher })
    
    assert_json_match(pattern, response.body)
  end
end
