class OrderItem < ApplicationRecord
  belongs_to :dish
  belongs_to :order

  enum status: { preparing: 0, completed: 1, cancelled: 2 }
end
