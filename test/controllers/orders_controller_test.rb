require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest

  RECORD_NOT_FOUND = ERROR_MESSAGES[:record_not_found] % ['Order', 'id', 0].freeze

  setup do
    @order = orders(:one)
    @user = users(:waiter)
  end

  test "index should return unauthorized when token is absent" do
    get orders_url
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "should get index" do
    get orders_url, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
    orders_response = JSON.parse(Order.includes(:order_items).to_json(include: :order_items))
    assert_equal [], (orders_response - response.parsed_body)
  end

  test "create should return unauthorized when token is absent" do
    post orders_url, params: { is_active: @order.is_active, table_no: @order.table_no }
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "create should return forbidden if current user is chef" do
    chef = users(:chef)
    post orders_url, params: { is_active: @order.is_active, table_no: @order.table_no }, headers: { 'Authorization': generate_jwt(chef) }
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)
  end

  test "should create order with order_items" do
    order_items = [{dish_id: dishes(:one).id, quantity: 3}, {dish_id: dishes(:two).id, quantity: 5}]
    payload = { table_no: @order.table_no, order_items: order_items }

    assert_difference ->{ Order.count } => 1, -> { OrderItem.count } => 2 do
      post orders_url, params: payload, headers: { 'Authorization': generate_jwt(@user) }
    end

    assert_response 201
    pattern = payload.merge({id: wildcard_matcher, is_active: true, user_id: @user.id, created_at: wildcard_matcher, updated_at: wildcard_matcher})
    pattern[:order_items].each { |order_item| order_item.merge!({id: wildcard_matcher, order_id: response.parsed_body['id'], status: 'preparing', created_at: wildcard_matcher, updated_at: wildcard_matcher}) }
    assert_json_match(pattern, response.body)
  end

  test "show should return unauthorized when token is absent" do
    get order_url(@order)
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "show should return not_found if order_id is invalid" do
    get order_url(0), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "should show order" do
    get order_url(@order), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
    assert_json_match(Order.find(@order.id).as_json(include: :order_items), response.body)
  end

  test "update should return unauthorized when token is absent" do
    put order_url(@order), params: { is_active: @order.is_active, table_no: @order.table_no }
    assert_response 401
    assert_json_match(error_response(ERROR_MESSAGES[:nil_token]), response.body)
  end

  test "update should return forbidden if current user is chef" do
    chef = users(:chef)
    post orders_url, params: { is_active: @order.is_active, table_no: @order.table_no }, headers: { 'Authorization': generate_jwt(chef) }
    assert_response 403
    assert_json_match(error_response(ERROR_MESSAGES[:not_privileged]), response.body)
  end

  test "update should return not_found if order_id is invalid" do
    put order_url(0), params: { is_active: @order.is_active, table_no: @order.table_no }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 404
    assert_json_match(error_response(RECORD_NOT_FOUND), response.body)
  end

  test "should update order and order_items" do
    order_items = [{id: order_items(:one).id, dish_id: dishes(:one).id, quantity: 10}, { dish_id: dishes(:two).id, quantity: 20 }]
    payload = { table_no: 100, order_items: order_items }

    assert_difference('OrderItem.count') do
      put order_url(@order), params: payload, headers: { 'Authorization': generate_jwt(@user) }
    end
    
    assert_response 200
    
    pattern = payload.merge({ id: @order.id, is_active: true, user_id: @user.id, created_at: @order.created_at, updated_at: wildcard_matcher })
    pattern[:order_items][0].merge! ({ order_id: @order.id, status: order_items(:one).status, created_at: order_items(:one).created_at, updated_at: wildcard_matcher })
    pattern[:order_items][1].merge! ({ id: wildcard_matcher, order_id: @order.id,  status: OrderItem.statuses.first[0], created_at: wildcard_matcher, updated_at: wildcard_matcher })
    
    assert_json_match(pattern, response.body)
  end
end
