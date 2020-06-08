require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  test "status is mandatory" do
    order_item = OrderItem.new(dish_id: Dish.first.id, order_id: Order.first.id, quantity: 1)
    refute order_item.valid?
    assert order_item.errors[:status].include?(ERROR_MESSAGES[:cant_be_blank])
  end

  test "minimum quantity value is 1" do
    order_item = OrderItem.new(dish_id: Dish.first.id, order_id: Order.first.id, status: 'preparing')
    refute order_item.valid?

    order_item = OrderItem.new(dish_id: Dish.first.id, order_id: Order.first.id, status: 'preparing', quantity: 0)
    refute order_item.valid?
    assert order_item.errors[:quantity].include?(ERROR_MESSAGES[:greater_than_equal_integer] % 1)
  end

  test "valid order item" do
    order_item = OrderItem.new(dish_id: Dish.first.id, order_id: Order.first.id, status: 'preparing', quantity: 1)
    assert order_item.valid?
  end
end
