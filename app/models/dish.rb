class Dish < ApplicationRecord
  belongs_to :account
  has_many :order_items, dependent: :destroy

  validates :name, :description, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0.01 }

  # Prevents cost being formatted in scientific notation
  def cost
    self[:cost].to_f
  end
end
