require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name is mandatory' do
    user = User.new(role: 'admin', email: 'test@test.com', password: '12345678')
    refute user.valid?
    assert user.errors.added? :name, :blank
  end

  test 'role is mandatory' do
    user = User.new(name: 'user1', email: 'test@test.com', password: '12345678')
    refute user.valid?
    assert user.errors.added? :role, :blank
  end

  test 'email is not mandatory' do
    user = User.new(name: 'user1', role: 'admin', password: '12345678')
    assert user.valid?
  end

  test 'email is of valid format' do
    user = User.new(name: 'user1', role: 'admin', email: 'invalid_email', password: '12345678')
    refute user.valid?
    assert user.errors.of_kind? :email, :invalid
  end

  test 'email uniqueness is case insensitive' do
    existing_user = User.create!(name: 'user1', email: 'UsEr@email.com', role: 'admin', password: '12345678')
    new_user = User.new(name: 'user2', email: 'user@email.com', role: 'admin', password: '12345678')
    refute new_user.valid?
    assert new_user.errors.of_kind? :email, :taken
  end

  test 'password minimun length must be 8' do
    user = User.new(name: 'user1', role: 'admin', email: 'test@test.com', password: '12')
    refute user.valid?
    assert user.errors.added? :password, :too_short, { count: 8 }
  end

  test 'valid user' do
    user = User.new(name: 'user1', role: 'admin', email: 'test@test.com', password: '12345678')
    assert user.valid?
  end
end
