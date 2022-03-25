class Order < ApplicationRecord
  belongs_to :account
  belongs_to :user
  
  has_many :order_items, dependent: :destroy
  has_one :bill

  validates :table_no, numericality: { greater_than_or_equal_to: 1 }
end
