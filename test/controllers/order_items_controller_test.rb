require 'test_helper'

class OrderItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @dish = dishes(:one)
    @order_item = order_items(:two)
    @user = users(:waiter)
  end

  test "index should return unauthorized when token is absent" do
    get order_items_url(@order.id)
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "should get index" do
    get order_items_url(@order.id), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end

  test "create should return unauthorized when token is absent" do
    post order_items_url(@order.id), params: { dish_id: 1, quantity: 1, status: 0 }
    assert_response 401
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:nil_token])
  end

  test "create should return forbidden if current user is chef" do
    chef = users(:chef)
    post order_items_url(@order.id), params: { dish_id: @dish.id, quantity: 1 }, headers: { 'Authorization': generate_jwt(chef) }
    assert_response 403
    assert parsed_response[:errors].include?(ERROR_MESSAGES[:not_privileged])
  end

  test "should create order_item" do
    assert_difference('OrderItem.count') do
      post order_items_url(0), params: { order_id: @order.id, dish_id: @dish.id, quantity: 1 }, headers: { 'Authorization': generate_jwt(@user) }
    end

    assert_response 201
  end

  test "should show order_item" do
    get :show, order_id: @order.id, id: @order_item.id, headers: { 'Authorization': generate_jwt(@user) }
    # get order_item_url(@order.id, @order_item.id), headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end

  test "should update order_item" do
    put order_item_url(@order.id, @order_item.id), params: { dish_id: @dish.id, quantity: 1 }, headers: { 'Authorization': generate_jwt(@user) }
    assert_response 200
  end
end
