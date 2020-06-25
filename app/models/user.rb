class User < ApplicationRecord
  include ApplicationConstants
  
  enum role: { admin: 0, waiter: 1, chef:2 }

  has_many :orders
  
  has_secure_password

  validates :name, :role, presence: true, on: :create
  validates :email, uniqueness: true, format: EMAIL_REGEX
  # validates :password, length: { minimum: 8 }, if: -> { new_record? }
  validates :password, length: { minimum: 8 }, allow_blank: true

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + RESET_PASSWORD_TOKEN_EXPIRY_TIME) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.update!(password: password, password_confirmation: password)
  end

  def facade
    self.attributes.except('password_digest', 'reset_password_token', 'reset_password_sent_at')
  end

  private

    def generate_token
      SecureRandom.hex(10)
    end
end
