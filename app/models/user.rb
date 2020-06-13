class User < ApplicationRecord
  include ApplicationConstants
  
  enum role: { admin: 0, waiter: 1, chef:2 }

  has_many :orders
  
  has_secure_password

  validates :name, :role, presence: true, on: :create
  validates :email, uniqueness: true, format: EMAIL_REGEX
  # validates :password, length: { minimum: 8 }, if: -> { new_record? }
  validates :password, length: { minimum: 8 }, allow_blank: true
end
