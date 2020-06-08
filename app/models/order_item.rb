class OrderItem < ApplicationRecord
  belongs_to :dish
  belongs_to :order

  enum status: { preparing: 0, completed: 1, cancelled: 2 }

  validates :status, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
end
