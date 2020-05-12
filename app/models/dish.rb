class Dish < ApplicationRecord
  validates :name, :description, :cost, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0.01 }

  #restrict access to create dish with current user's role
end
