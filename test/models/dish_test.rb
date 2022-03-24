require 'test_helper'

class DishTest < ActiveSupport::TestCase
  test 'name is mandatory' do
    dish = Dish.new(description: 'text', cost: 10)
    refute dish.valid?
    assert dish.errors.added? :name, :blank
  end

  test 'description is mandatory' do
    dish = Dish.new(name: 'name', cost: 10)
    refute dish.valid?
    assert dish.errors.added? :description, :blank
  end

  test 'cost must be greater than or equal to 0.01' do
    dish = Dish.new(name: 'name', description: 'text')
    refute dish.valid?

    dish = Dish.new(name: 'name', description: 'text', cost: 0.0)
    refute dish.valid?
    dish.errors.added? :cost, :greater_than_or_equal_to, value: 0.0, count: 0.01
  end

  test 'valid dish' do
    dish = Dish.new(name: 'name', description: 'text', cost:10.0)
    assert dish.valid?
  end
end
