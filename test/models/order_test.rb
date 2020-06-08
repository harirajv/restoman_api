require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'table_no must be positive' do
    order = Order.new(table_no: -1)
    refute order.valid?
    assert order.errors[:table_no].include?(ERROR_MESSAGES[:greater_than_equal_integer] % 1)
  end

  test 'is_active default value is true' do
    order = Order.new(table_no: 1, user_id: User.first.id)
    assert order.valid?
    assert_equal order.is_active, true
  end

  test 'valid order' do
    order = Order.new(table_no: 1, user_id: User.first.id)
    assert order.valid?
  end
end
