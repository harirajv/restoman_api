require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'table_no must be positive' do
    order = Order.new(table_no: -1)
    refute order.valid?
    assert order.errors.added? :table_no, :greater_than_or_equal_to, value: -1, count: 1
  end

  test 'is_active default value is true' do
    order = Order.new(table_no: 1, user: users(:admin), account: accounts(:one))
    assert order.valid?
    assert_equal order.is_active, true
  end

  test 'account must exist' do
    order = Order.new(table_no: 1, user: users(:admin))
    refute order.valid?
    assert order.errors.added? :account, :blank
  end

  test 'valid order' do
    order = Order.new(table_no: 1, user: users(:admin), account: accounts(:one))
    assert order.valid?
  end
end
