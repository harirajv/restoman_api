class Dish < ApplicationRecord
  has_many :order_items, dependent: :destroy

  validates :name, :description, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0.01 }

  #restrict access to create dish with current user's role
end
