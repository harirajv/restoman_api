class Bill < ApplicationRecord
  belongs_to :order

  enum payment_mode: { cash: 0, card: 1 }

  validates :payment_mode, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0.01 }
end
