class Order < ApplicationRecord
  belongs_to :user
  
  has_many :order_items, dependent: :destroy
  has_one :bill
end
