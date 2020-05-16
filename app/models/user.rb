class User < ApplicationRecord
  has_secure_password
  
  enum role: { admin: 0, waiter: 1, chef:2 }

  validates :name, :role, :email, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
end
