class Account < ApplicationRecord
  has_many :dishes
  has_many :orders
  has_many :bills, through: :orders
  has_many :users

  validates_presence_of :name
  validates_presence_of :subdomain
  validates_uniqueness_of :subdomain

  before_validation :downcase_subdomain, if: :subdomain_changed?

  def full_domain
    "#{subdomain}.restoman.com"
  end

  private
    def downcase_subdomain
      subdomain.downcase!
    end
end
