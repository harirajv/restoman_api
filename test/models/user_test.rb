require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name is mandatory' do
    user = User.new(role: 'admin', email: 'test@test.com', password: '12345678')
    refute user.valid?
    assert user.errors[:name].include?(ERROR_MESSAGES[:cant_be_blank])
  end

  test 'role is mandatory' do
    user = User.new(name: 'user1', email: 'test@test.com', password: '12345678')
    refute user.valid?
    assert user.errors[:role].include?(ERROR_MESSAGES[:cant_be_blank])
  end

  test 'email is not mandatory' do
    user = User.new(name: 'user1', role: 'admin', password: '12345678')
    assert user.valid?
  end

  test 'email is of valid format' do
    user = User.new(name: 'user1', role: 'admin', email: 'invalid_email', password: '12345678')
    refute user.valid?
    assert user.errors[:email].include?(ERROR_MESSAGES[:is_invalid])
  end

  test 'email uniqueness is case insensitive' do
    existing_user = User.create!(name: 'user1', email: 'UsEr@email.com', role: 'admin', password: '12345678')
    new_user = User.new(name: 'user2', email: 'user@email.com', role: 'admin', password: '12345678')
    refute new_user.valid?
    assert_equal 'has already been taken', new_user.errors.messages[:email].first
  end

  test 'password minimun length must be 8' do
    user = User.new(name: 'user1', role: 'admin', email: 'test@test.com', password: '12')
    refute user.valid?
    assert user.errors[:password].include?(ERROR_MESSAGES[:too_short_min_is] % 8)
  end

  test 'valid user' do
    user = User.new(name: 'user1', role: 'admin', email: 'test@test.com', password: '12345678')
    assert user.valid?
  end
end
