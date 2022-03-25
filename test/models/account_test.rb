require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test 'name and subdomain are mandatory' do
    account = Account.new
    refute account.valid?
    assert account.errors.added? :name, :blank
    assert account.errors.added? :subdomain, :blank
  end

  test 'subdomain is always downcased' do
    account = accounts(:one)
    account.subdomain = 'AbCd'
    account.save!
    assert_equal 'abcd', account.subdomain
  end

  test 'sudomain must be unique' do
    acc1 = accounts(:one)
    acc2 = accounts(:two)
    acc1.subdomain = acc2.subdomain
    refute acc1.valid?
    assert acc1.errors.added? :subdomain, :taken, value: acc2.subdomain
  end

  test 'valid account' do
    account = Account.new name: 'abc', subdomain: 'abc'
    assert account.valid?
  end
end
