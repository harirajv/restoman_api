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
    assert_difference ->{ Order.count } => 1, -> { OrderItem.count } => 2 do
      post orders_url, params: { table_no: @order.table_no, order_items: order_items }, headers: { 'Authorization': generate_jwt(@user) }
    end

    assert_response 201
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
    assert_difference('OrderItem.count') do
      put order_url(@order), params: { table_no: 100, order_items: order_items }, headers: { 'Authorization': generate_jwt(@user) }
    end
    
    assert_response 200
  end
end
