require 'test_helper'

class OrderItemsControllerTest < ActionDispatch::IntegrationTest

  ORDER_NOT_FOUND = ERROR_MESSAGES[:record_not_found] % ['Order', 'id', 0].freeze
  ORDER_ITEM_NOT_FOUND = ERROR_MESSAGES[:record_not_found] % ['OrderItem', 'id', 0].freeze

  setup do
    @order = orders(:two)
    @dish = dishes(:one)
    @order_item = order_items(:two)
    @user = users(:waiter)
  end

  test "index should return unauthorized when token is absent" do
    get order_order_items_url(@order.id)
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "should get index" do
    get order_order_items_url(@order.id), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end

  test "create should return unauthorized when token is absent" do
    post order_order_items_url(@order.id), params: { dish_id: 1, quantity: 1, status: 0 }
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "create should return forbidden if current user is chef" do
    chef = users(:chef)
    post order_order_items_url(@order.id), params: { dish_id: @dish.id, quantity: 1 }, headers: { 'Authorization': generate_jwt(chef) }
    assert_response 403
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:not_privileged])
  end

  test "should create order_item" do
    assert_difference('OrderItem.count') do
      post order_order_items_url(@order.id), params: { dish_id: @dish.id, quantity: 1 }, headers: { 'Authorization': generate_jwt(@user) }
    end

    assert_response 201
  end

  test "show should return unauthorized when token is absent" do
    get order_order_item_url(@order, @order_item)
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "show should return not_found if order_id is invalid" do
    get order_order_item_url(0, @order_item), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 404
    assert parsed_response[:errors].include?(ORDER_NOT_FOUND)
  end

  test "show should return not_found if order_item_id is invalid" do
    get order_order_item_url(@order, 0), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 404
    assert parsed_response[:errors].include?(ORDER_ITEM_NOT_FOUND)
  end

  test "should show order_item" do
    get order_order_item_url(@order, @order_item), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end

  test "update should return unauthorized when token is absent" do
    put order_order_item_url(@order, @order_item), params: { dish_id: @dish.id, quantity: 1 }
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "update should return not_found if order_id is invalid" do
    put order_order_item_url(0, @order_item), params: { dish_id: @dish.id, quantity: 1 }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 404
    assert parsed_response[:errors].include?(ORDER_NOT_FOUND)
  end

  test "update should return not_found if order_item_id is invalid" do
    put order_order_item_url(@order, 0), params: { dish_id: @dish.id, quantity: 1 }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 404
    assert parsed_response[:errors].include?(ORDER_ITEM_NOT_FOUND)
  end

  test "should update order_item" do
    put order_order_item_url(@order, @order_item), params: { dish_id: @dish.id, quantity: 1 }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end
end
