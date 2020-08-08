class OrderItem < ApplicationRecord
  belongs_to :dish
  belongs_to :order

  enum status: { preparing: 0, completed: 1, cancelled: 2 }

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }, presence: true
  validate :quantity_and_status_changed, on: :update

  private

  def quantity_and_status_changed
    errors.add(:base, "Quantity and status cannot be changed at same time") if quantity_changed? &&
                                                                               status_changed?
  end
end
