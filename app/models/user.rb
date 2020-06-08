class User < ApplicationRecord
  include ApplicationConstants

  has_secure_password
  
  enum role: { admin: 0, waiter: 1, chef:2 }

  validates :name, :role, presence: true
  validates :email, uniqueness: true, format: EMAIL_REGEX
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  # password length validation will not work for update of password
end
