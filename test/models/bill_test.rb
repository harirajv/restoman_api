require 'test_helper'

class BillTest < ActiveSupport::TestCase
  test "payment_mode is mandatory" do
    bill = Bill.new(order_id: Order.first.id, cost:10.00)
    refute bill.valid?
    assert bill.errors.added? :payment_mode, :blank
  end

  test "minimum value for cost is 0.01" do
    bill = Bill.new(order_id: Order.first.id)
    refute bill.valid?

    bill = Bill.new(order_id: Order.first.id, payment_mode: 'cash', cost: -1)
    refute bill.valid?
    assert bill.errors.added? :cost, :greater_than_or_equal_to, value: -1, count: 0.01
  end

  test "valid bill" do
    bill = Bill.new(order_id: orders(:one).id, payment_mode: 'cash', cost: 1)
    assert bill.valid?
  end
end
