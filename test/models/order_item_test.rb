require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  test "quantity is mandatory" do
    order_item = OrderItem.new(dish_id: Dish.first.id, order_id: Order.first.id)
    refute order_item.valid?
    assert order_item.errors.added? :quantity, :blank
  end

  test "minimum quantity value is 1" do
    order_item = OrderItem.new(dish_id: Dish.first.id, order_id: Order.first.id, status: OrderItem.statuses[:preparing])
    refute order_item.valid?

    order_item = OrderItem.new(dish_id: Dish.first.id, order_id: Order.first.id, status: OrderItem.statuses[:preparing], quantity: 0)
    refute order_item.valid?
    assert order_item.errors.added? :quantity, :greater_than_or_equal_to, value: 0, count: 1
  end

  test "quantity and status cannot be updated at same time" do
    order_item = OrderItem.create(dish_id: Dish.first.id, order_id: Order.first.id, quantity: 1)
    order_item.quantity = 10
    order_item.status = OrderItem.statuses[:cancelled]
    refute order_item.valid?
    assert order_item.errors[:base].include?("Quantity and status cannot be changed at same time")
  end

  test "valid order item" do
    order_item = OrderItem.new(dish_id: Dish.first.id, order_id: Order.first.id, status: OrderItem.statuses[:preparing], quantity: 1)
    assert order_item.valid?
  end
end
